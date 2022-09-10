library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.aegis256_round_pkg.all;

entity roundupdate is
    generic (rf_conf : rf_t_enum;
	         sb_conf : sb_t_enum;
	         mc_conf : mc_t_enum);
    port (si : in  state_t_arr;
          so : out state_t_arr;

          x : in std_logic_vector(127 downto 0));
end entity;

architecture structural of roundupdate is
    
    signal t : std_logic_vector(127 downto 0);

begin

    t <= x xor si(0);
    
    aes0   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(5), t,     so(0));
    aes1   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(0), si(1), so(1));
    aes2   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(1), si(2), so(2));
    aes3   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(2), si(3), so(3));
    aes4   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(3), si(4), so(4));
    aes5   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(4), si(5), so(5));

end architecture;
