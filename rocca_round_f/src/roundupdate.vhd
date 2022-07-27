library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.rocca_round_f_pkg.all;

entity roundupdate is
    generic (rf_conf : rf_t_enum;
	     sb_conf : sb_t_enum;
	     mc_conf : mc_t_enum);
    port (si : in  state_t_arr;
          so : out state_t_arr;

          x0 : in std_logic_vector(127 downto 0);
          x1 : in std_logic_vector(127 downto 0));
end entity;

architecture structural of roundupdate is
begin

    so(0) <= si(1) xor si(6);
    aes0   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(0), x0,    so(1));
    aes1   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(1), si(0), so(2));
    aes2   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(2), si(6), so(3));
    aes3   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(3), x1,    so(4));
    aes4   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(4), si(3), so(5));
    aes5   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (si(5), si(4), so(6));

end architecture;
