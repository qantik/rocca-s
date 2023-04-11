library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.rocca_round_s_pkg.all;

entity rocca_round_s is
    generic (rf_conf : rf_t_enum := rf_split_e;
	     sb_conf : sb_t_enum := sb_tradeoff_e;
	     mc_conf : mc_t_enum := mc_fast_e);
    port (clk   : in std_logic;
          reset : in std_logic;

          nonce : in std_logic_vector(127 downto 0);
          key   : in std_logic_vector(255 downto 0);
       
          last_block : in std_logic;
          
          data      : in std_logic_vector(255 downto 0);
          ad_len    : in std_logic_vector(127 downto 0);
          ad_empty  : in std_logic;
          msg_len   : in std_logic_vector(127 downto 0);
          msg_empty : in std_logic;
          
          ct        : out std_logic_vector(255 downto 0);
          tag       : out std_logic_vector(255 downto 0));
end entity;

architecture structural of rocca_round_s is

    signal k0, k1 : std_logic_vector(127 downto 0);

    signal sr_in   : state_t_arr;
    signal sr_in_t : state_t_arr; 
    signal sr_out  : state_t_arr;
    signal sr_init : state_t_arr;

    signal ru_in      : state_t_arr;
    signal ru_out     : state_t_arr; 
    signal ru_aux_in  : std_logic_vector(255 downto 0);
    signal ru_aux_out : std_logic_vector(255 downto 0); 
    
    signal sr_load_en, sr56_sel : std_logic;
    signal ru_aux_sel           : std_logic_vector(1 downto 0);

    signal length : std_logic_vector(255 downto 0);
    
    constant z0 : std_logic_vector(127 downto 0)  := X"CD65EF239144377122AE28D7982F8A42";
    constant z1 : std_logic_vector(127 downto 0)  := X"BCDB8981A5DBB5E92F3B4DECCFFBC0B5";
    constant z  : std_logic_vector (255 downto 0) := z0 & z1;

    signal epoch : std_logic;

begin
    
    k0     <= key(255 downto 128);
    k1     <= key(127 downto 0);
    length <= ad_len & msg_len;

    sr_in(0) <= k1               when sr_load_en = '1' else
		ru_out(0) xor k0 when sr56_sel   = '1' else ru_out(0);
    sr_in(1) <= nonce            when sr_load_en = '1' else
		ru_out(1) xor k0 when sr56_sel   = '1' else ru_out(1); 
    sr_in(2) <= z0               when sr_load_en = '1' else
		ru_out(2) xor k1 when sr56_sel   = '1' else ru_out(2); 
    sr_in(3) <= k0               when sr_load_en = '1' else
		ru_out(3) xor k0 when sr56_sel   = '1' else ru_out(3);
    sr_in(4) <= z1               when sr_load_en = '1' else
		ru_out(4) xor k0 when sr56_sel   = '1' else ru_out(4);
    sr_in(5) <= nonce xor k1     when sr_load_en = '1' else
		ru_out(5) xor k1 when sr56_sel   = '1' else ru_out(5); 
    sr_in(6) <= (others => '0')  when sr_load_en = '1' else
		ru_out(6) xor k1 when sr56_sel   = '1' else ru_out(6); 

    s0_reg : entity state_reg port map (clk, sr_in(0), sr_out(0));
    s1_reg : entity state_reg port map (clk, sr_in(1), sr_out(1));
    s2_reg : entity state_reg port map (clk, sr_in(2), sr_out(2));
    s3_reg : entity state_reg port map (clk, sr_in(3), sr_out(3));
    s4_reg : entity state_reg port map (clk, sr_in(4), sr_out(4));
    s5_reg : entity state_reg port map (clk, sr_in(5), sr_out(5));
    s6_reg : entity state_reg port map (clk, sr_in(6), sr_out(6));

    ru_aux_in <= data   when ru_aux_sel = "01" else
		 length when ru_aux_sel = "10" else z;  
    
    ru : entity roundupdate generic map (rf_conf, sb_conf, mc_conf) port map (
        sr_out, ru_out, epoch, ru_aux_in(255 downto 128), ru_aux_in(127 downto 0)
    );

    --
    -- control signals
    --
    cont : entity controller port map (
        clk, reset, last_block, ad_empty, msg_empty, epoch, sr_load_en, sr56_sel, ru_aux_sel
    );

    f0_gen : entity f0 generic map (rf_conf, sb_conf, mc_conf) port map(sr_out, data, ct);
    tg     : entity taggen port map (sr_out, tag);

end architecture;
         

