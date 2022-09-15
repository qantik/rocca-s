library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity fr2 is
  port(
        R1 : in std_logic_vector(127 downto 0);
        R2n : out std_logic_vector(127 downto 0)
      );
end;


architecture ballif of fr2 is
begin

    aesrf0: entity aes_rf port map (R1, R2n);
    
end architecture ballif;

