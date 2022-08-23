library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

entity taggen is
    port (s0, s1, s2, s3, s4, s5, s6 : in  std_logic_vector(7 downto 0);
          tag                        : out std_logic_vector(15 downto 0));
end entity;

architecture parallel of taggen is
begin

    tag <= (s0 xor s1 xor s2 xor s3) & (s4 xor s5 xor s6);

end architecture;


