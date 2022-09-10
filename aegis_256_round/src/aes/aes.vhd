library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.aegis256_round_pkg.all;

entity aes is
    generic (rf_conf : rf_t_enum;
	         sb_conf : sb_t_enum;
	         mc_conf : mc_t_enum);
    port (x : in  std_logic_vector(127 downto 0);
          k : in  std_logic_vector(127 downto 0);
          y : out std_logic_vector(127 downto 0));
end entity;

architecture structural of aes is

    signal sbox_out       : std_logic_vector(127 downto 0);
    signal shiftrows_out  : std_logic_vector(127 downto 0);
    signal mixcolumns_out : std_logic_vector(127 downto 0);
    signal mixttable_out  : std_logic_vector(127 downto 0);

begin

    rf_split_gen : if rf_conf = rf_split_e generate
        subbytes_gen    : entity subbytes  generic map (sb_conf) port map (x, sbox_out);
        shiftrows_gen   : entity shiftrows  port map (sbox_out, shiftrows_out);
        mixcolumns_gen  : entity mixcolumns generic map (mc_conf)  port map (shiftrows_out, mixcolumns_out);
        addroundkey_gen : entity addroundkey port map (mixcolumns_out, k, y);
    end generate;

    rf_ttable_gen : if rf_conf = rf_ttable_e generate
        mixttable_gen   : entity mixttable   port map (x, mixttable_out);
        addroundkey_gen : entity addroundkey port map (mixttable_out, k, y);
    end generate;

end architecture;

