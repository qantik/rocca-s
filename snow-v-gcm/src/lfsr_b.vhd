library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity lfsr_b is
  port(
        A : in std_logic_vector(255 downto 0);
        B : in std_logic_vector(255 downto 0);
        Bn : out std_logic_vector(255 downto 0)
      );
end;

architecture structural of lfsr_b is
    signal tmp: std_logic_vector(127 downto 0);
begin

    Bn(255 downto 128) <= B(127 downto 0);
    lfsr_b: for i in 0 to 7 generate
        mul_xb: entity mul_b port map (
            B(16*(i+8) + 15 downto 16*(i+8)), 
            B(16*(i+5) + 15 downto 16*(i+5)), 
            B(16*(i) + 15 downto 16*(i)), 
            A(16*(7-i) + 15 downto 16*(7-i)), 
            tmp(16*i + 15 downto 16*i) 
            );
    end generate;

    Bn(127 downto 0) <= tmp;

end architecture;

