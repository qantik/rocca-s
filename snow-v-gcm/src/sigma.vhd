library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity sigma is
  port(
        A : in std_logic_vector(127 downto 0);
        An: out std_logic_vector(127 downto 0)
      );
end;

architecture parallel of sigma is

    subtype int15type is integer range 0 to 15;
    type intarray is array (0 to 15) of int15type;
    constant sigma_table : intarray := (0, 4, 8, 12, 1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15);
begin
    
    gen : for i in 0 to 15 generate
        An(127 - 8*i downto 120 - 8*i) <= A(127 - 8*sigma_table(i) downto 120 - 8*sigma_table(i));
    end generate;
    
end architecture;

