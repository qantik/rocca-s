library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity fb is
  port(
        A : in std_logic_vector(255 downto 0);
        B : in std_logic_vector(255 downto 0);
        Bn : out std_logic_vector(255 downto 0)
      );
end;

architecture parallel of fb is
begin

    lfsr_b0 : entity lfsr_b port map(A, B, Bn);
    		
end architecture;

