library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.rocca_round_s_pkg.all;

entity f0 is
    generic (rf_conf : rf_t_enum := rf_split_e;
	     sb_conf : sb_t_enum := sb_fast_e;
	     mc_conf : mc_t_enum := mc_fast_e);
    port (s    : in  state_t_arr;
          data : in  std_logic_vector(255 downto 0);
          ct   : out std_logic_vector(255 downto 0));
end entity;

architecture parallel of f0 is
    
    signal aes0_pt : std_logic_vector(127 downto 0);
    signal aes0_ct : std_logic_vector(127 downto 0);

    signal aes1_pt : std_logic_vector(127 downto 0);
    signal aes1_ct : std_logic_vector(127 downto 0);

    signal x0, x1 : std_logic_vector(127 downto 0);

begin

    x0 <= data(255 downto 128);
    x1 <= data(127 downto 0);

    aes0_pt <= s(3) xor s(5);
    aes0 : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (aes0_pt, s(0), aes0_ct);
    ct(255 downto 128) <= aes0_ct xor x0;
    
    aes1_pt <= s(4) xor s(6);
    aes1 : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (aes1_pt, s(2), aes1_ct);
    ct(127 downto 0) <= aes1_ct xor x1;

end architecture;

