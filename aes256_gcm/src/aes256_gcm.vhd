library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.aes256_gcm_pkg.all;

entity aes256_gcm is
    generic (rf_conf : rf_t_enum := rf_ttable_e;
	         sb_conf : sb_t_enum := sb_fast_e;
	         mc_conf : mc_t_enum := mc_fast_e);
    port (clk     : in std_logic;
          reset_n : in std_logic;

          iv  : in std_logic_vector(95 downto 0);
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

architecture structural of aes256_gcm is

    signal state : state_type;
    signal cycle : unsigned(3 downto 0);
    signal count : unsigned(31 downto 0);

    signal length : std_logic_vector(127 downto 0);
    
    type inter_t_arr is array (0 to r-1) of std_logic_vector(127 downto 0);
    type count_t_arr is array (0 to r-1) of std_logic_vector(31 downto 0);

    signal aes_start : std_logic;
    signal aes_key   : std_logic_vector(255 downto 0);
    signal aes_pt    : inter_t_arr;
    signal aes_ct    : inter_t_arr;

    signal gh_load : std_logic;
    signal hk_load : std_logic;
    signal tg_load : std_logic;

    signal gh_in, gh_out : std_logic_vector(127 downto 0);
    signal hk_in, hk_out : std_logic_vector(127 downto 0);
    signal tg_in, tg_out : std_logic_vector(127 downto 0);

    signal mult_in0, mult_out : inter_t_arr;
    signal mult_in1 : std_logic_vector(127 downto 0);

    signal datai   : inter_t_arr;
    signal cti     : inter_t_arr;
    signal gh_t    : inter_t_arr;
    signal ct_t    : inter_t_arr;
    signal count_t : count_t_arr;

begin

    tag <= tg_out xor mult_out(0); 

    length <= ad_len(56 downto 0) & "0000000" & msg_len(56 downto 0) & "0000000";

    aes_key <= key;
    aes_start <= '1' when
      cycle = 0 and (state = hk_state or state = tg_state or state = msg_state) else '0';

    gh_in <= mult_out(r-1);
    hk_in <= aes_ct(0);
    tg_in <= aes_ct(0);
    gh_load <= '1' when ((state = hk_state or state = msg_state) and cycle = 15) or (state = ad_state) else '0';
    hk_load <= '1' when state = hk_state and cycle = 15 else '0';
    tg_load <= '1' when state = tg_state and cycle = 15 else '0';

    gh_t(0) <= gh_out;
    mux_gen : for i in 0 to r-1 generate
        datai(i) <= data(128*(i+1)-1 downto 128*i);
        ct(128*(i+1)-1 downto 128*i) <= cti(i);

        count_t(i) <= std_logic_vector(count+i); 
        aes_pt(i)  <= (others => '0') when state = hk_state else iv & count_t(i);
        cti(i) <= ct_t(i);

        gh_t_gen : if i > 0 generate
            gh_t(i) <= mult_out(i-1);
        end generate;

        ct_t(i) <= aes_ct(i) xor datai(i);
        with state select
            mult_in0(i) <= datai(i) xor gh_t(i) when ad_state,
                           ct_t(i)  xor gh_t(i) when msg_state,
                           length   xor gh_t(i) when tag_state,
                           (others => '0')      when others;
    end generate;
    mult_in1 <= hk_out;

    gh_reg : entity dff port map (clk, gh_load, gh_in, gh_out);
    hk_reg : entity dff port map (clk, hk_load, hk_in, hk_out);
    tg_reg : entity dff port map (clk, tg_load, tg_in, tg_out);
   
    core_gen : for i in 0 to r-1 generate
        aes_gen : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (
            clk, reset_n, aes_start, key, aes_pt(i), aes_ct(i), cycle
        );
        gf_gen : entity gf128_mult port map (mult_in0(i), mult_in1, mult_out(i)); 
    end generate;

    cont : entity controller port map (
        clk, reset_n, start, last_block, ad_empty, msg_empty, cycle, count, state
    );

end architecture;

