library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

entity f2 is
    port (s0, s1, s2, s3, s4, s5, s6 : in std_logic_vector(7 downto 0);
          data                       : in  std_logic_vector(15 downto 0);
          ct                         : out std_logic_vector(15 downto 0));
end entity;

architecture parallel of f2 is

    signal x0, x1 : std_logic_vector(7 downto 0);

begin

    x0 <= data(15 downto 8);
    x1 <= data(7 downto 0);

    ct(15 downto 8) <= (s4 and s6) xor s1 xor s2 xor x0;
    ct(7 downto 0)   <= (s2 and s5) xor s0 xor s3 xor x1;

end architecture;

