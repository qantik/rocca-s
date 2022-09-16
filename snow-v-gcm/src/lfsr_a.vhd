library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity lfsr_a is
  port(
        A : in std_logic_vector(255 downto 0);
        B : in std_logic_vector(255 downto 0);
        An : out std_logic_vector(255 downto 0)
      );
end;

architecture structural of lfsr_a is
    signal tmp : std_logic_vector(127 downto 0);
begin

    An(127 downto 0) <= A(255 downto 128);
    lfsra: for i in 0 to 7 generate
        mul_xa: entity mul_a port map (
            A(16*i + 15 downto 16*i), 
            A(16*(i+1) + 15 downto 16*(i+1)), 
            A(16*(i+8) + 15 downto 16*(i+8)), 
            B(16*(15-i) + 15 downto 16*(15-i)), 
            tmp(16*i + 15 downto 16*i) 
            );
    end generate;
    An(255 downto 128) <= tmp;

end architecture;

