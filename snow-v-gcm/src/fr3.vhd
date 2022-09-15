library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity fr3 is
  port(
        R2 : in std_logic_vector(127 downto 0);
        R3n : out std_logic_vector(127 downto 0)
      );
end;


architecture ballif of fr3 is
begin

    aesrf0: entity aes_rf port map (R2, R3n);
    
end architecture ballif;

