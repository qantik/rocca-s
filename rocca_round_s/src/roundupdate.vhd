library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.rocca_round_s_pkg.all;

entity roundupdate is
    generic (rf_conf : rf_t_enum := rf_split_e;
	     sb_conf : sb_t_enum := sb_fast_e;
	     mc_conf : mc_t_enum := mc_fast_e);
    port (si    : in  state_t_arr;
          so    : out state_t_arr;
          epoch : in  std_logic;

          x0 : in std_logic_vector(127 downto 0);
          x1 : in std_logic_vector(127 downto 0));
end entity;

architecture structural of roundupdate is

    signal t_in, t_out, t_key_in : state_t_arr;

begin

    --s0_xor : entity xor2 port map (si(1), si(6), so(0));
    --aes0   : entity aes generic map (SPLIT_CONF) port map (si(0), x0,    so(1));
    --aes1   : entity aes generic map (SPLIT_CONF) port map (si(1), si(0), so(2));
    --aes2   : entity aes generic map (SPLIT_CONF) port map (si(2), si(6), so(3));
    --aes3   : entity aes generic map (SPLIT_CONF) port map (si(3), x1,    so(4));
    --aes4   : entity aes generic map (SPLIT_CONF) port map (si(4), si(3), so(5));
    --aes5   : entity aes generic map (SPLIT_CONF) port map (si(5), si(4), so(6));
    
    --s0_xor : entity xor2 port map (t_in(0), t_key_in(0), t_out(0));
    t_out(0) <= t_in(0) xor t_key_in(0);
    aes0   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (t_in(1), t_key_in(1), t_out(1));
    aes1   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (t_in(2), t_key_in(2), t_out(2));
    aes2   : entity aes generic map (rf_conf, sb_conf, mc_conf) port map (t_in(3), t_key_in(3), t_out(3));

    epoch_mux : process(all)
    begin
        if epoch = '0' then
            t_in(0)     <= si(6);
            t_in(1)     <= si(0);
            t_in(2)     <= si(1);
            t_in(3)     <= si(2);
            
            t_key_in(0) <= si(1);
            t_key_in(1) <= x0;
            t_key_in(2) <= si(0);
            t_key_in(3) <= si(6);

            so(0) <= t_out(0);
            so(1) <= t_out(1);
            so(2) <= t_out(2);
            so(3) <= t_out(3);
            so(4) <= si(3);
            so(5) <= si(4);
            so(6) <= si(5);
        else
            t_in(0)     <= si(0);
            t_in(1)     <= si(4);
            t_in(2)     <= si(5);
            t_in(3)     <= si(6);
            
            t_key_in(0) <= (others => '0');
            t_key_in(1) <= x1;
            t_key_in(2) <= si(4);
            t_key_in(3) <= si(5);

            so(0) <= t_out(0);
            so(1) <= si(1);
            so(2) <= si(2);
            so(3) <= si(3);
            so(4) <= t_out(1);
            so(5) <= t_out(2);
            so(6) <= t_out(3);
        end if;

    end process;

end architecture;
