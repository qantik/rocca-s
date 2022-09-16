library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.all;
use work.snow_gcm_pkg.all;

entity fr2 is
  generic (rf_conf : rf_t_enum := rf_split_e;
           sb_conf : sb_t_enum := sb_fast_e;
           mc_conf : mc_t_enum := mc_fast_e);
  port(
        R1 : in std_logic_vector(127 downto 0);
        R2n : out std_logic_vector(127 downto 0)
      );
end;


architecture ballif of fr2 is
begin

    aesrf0: entity aes generic map (rf_conf, sb_conf, mc_conf) port map (R1, R2n);
    
end architecture ballif;

