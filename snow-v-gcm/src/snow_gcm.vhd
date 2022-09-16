library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.snow_gcm_pkg.all;

entity snow_gcm is
    generic (rf_conf    : rf_t_enum    := rf_ttable_e;
	         sb_conf    : sb_t_enum    := sb_fast_e;
	         mc_conf    : mc_t_enum    := mc_fast_e;
             adder_conf : adder_t_enum := adder_bk_e);
    port (clk     : in std_logic;
          reset_n : in std_logic;

          iv  : in std_logic_vector(127 downto 0);
          key : in std_logic_vector(255 downto 0);
          
          start      : in std_logic; 
          last_block : in std_logic;
          
          data      : in std_logic_vector(128*r-1 downto 0);
          ad_len    : in std_logic_vector(63 downto 0);
          ad_empty  : in std_logic;
          msg_len   : in std_logic_vector(63 downto 0);
          msg_empty : in std_logic;
          
          ct        : out std_logic_vector(128*r-1 downto 0);
          tag       : out std_logic_vector(127 downto 0));
end entity;

architecture structural of snow_gcm is

    signal state : state_type;
    signal cycle : unsigned(4 downto 0);

    signal length : std_logic_vector(127 downto 0);
    
    type inter_t_arr is array (0 to r-1) of std_logic_vector(127 downto 0);

    signal gh_load : std_logic;
    signal hk_load : std_logic;
    signal tg_load : std_logic;

    signal gh_in, gh_out : std_logic_vector(127 downto 0);
    signal hk_in, hk_out : std_logic_vector(127 downto 0);
    signal tg_in, tg_out : std_logic_vector(127 downto 0);

    signal mult_in0, mult_out : inter_t_arr;
    signal mult_in1 : std_logic_vector(127 downto 0);

    signal z       : std_logic_vector(128*r-1 downto 0);
    signal zi      : inter_t_arr;
    signal datai   : inter_t_arr;
    signal gh_t    : inter_t_arr;
    signal ct_t    : inter_t_arr;

    signal run : std_logic;

begin

    run <= '1' when state = load_state or state = msg_state else '0';

    tag <= tg_out xor mult_out(0); 

    length <= ad_len(56 downto 0) & "0000000" & msg_len(56 downto 0) & "0000000";

    gh_in <= mult_out(r-1);
    hk_in <= zi(0);
    tg_in <= zi(r-1);
    gh_load <= '1' when state = load_state or state = ad_state or state = msg_state else '0';
    hk_load <= '1' when state = load_state and cycle = (16/r)+1 else '0';
    tg_load <= '1' when state = load_state and cycle = (16/r)+(2/r) else '0';

    gh_t(0) <= gh_out;
    mux_gen : for i in 0 to r-1 generate
        zi(i) <= z(128*(i+1)-1 downto 128*i);
        datai(i) <= data(128*(i+1)-1 downto 128*i);
        ct(128*(i+1)-1 downto 128*i) <= ct_t(i);

        gh_t_gen : if i > 0 generate
            gh_t(i) <= mult_out(i-1);
        end generate;

        ct_t(i) <= zi(i) xor datai(i);
        with state select
            mult_in0(i) <= datai(i) xor gh_t(i) when ad_state,
                           ct_t(i)  xor gh_t(i) when msg_state,
                           length   xor gh_t(i) when tag_state,
                           (others => '0')      when others;
        
        gf_gen : entity gf128_mult port map (mult_in0(i), mult_in1, mult_out(i)); 
    end generate;
    mult_in1 <= hk_out;

    gh_reg : entity dff port map (clk, gh_load, gh_in, gh_out);
    hk_reg : entity dff port map (clk, hk_load, hk_in, hk_out);
    tg_reg : entity dff port map (clk, tg_load, tg_in, tg_out);

    cont : entity controller port map (
        clk, reset_n, start, last_block, ad_empty, msg_empty, cycle, state
    );

    snow_gen : entity snow generic map (rf_conf, sb_conf, mc_conf, adder_conf) port map (
        clk, cycle, key, iv, z, run
    );

end architecture;

