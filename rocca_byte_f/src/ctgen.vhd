library ieee;
use ieee.std_logic_1164.all;

entity ctgen is
    port (x0, x1  : in  std_logic_vector(7 downto 0);
          y0, y1  : in  std_logic_vector(7 downto 0);
          d0, d1  : in  std_logic_vector(7 downto 0);
          ct      : out std_logic_vector(15 downto 0));
end entity;

architecture parallel of ctgen is
begin

    ct(15 downto 8) <= x0 xor y0 xor d0;
    ct(7 downto 0)  <= x1 xor y1 xor d1;

end architecture;

