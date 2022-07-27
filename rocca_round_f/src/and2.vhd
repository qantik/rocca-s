library ieee;
use ieee.std_logic_1164.all;

entity and2 is
    generic (size : integer := 128);
    port (x : in std_logic_vector(size-1 downto 0);
          y : in std_logic_vector(size-1 downto 0);
          z : out std_logic_vector(size-1 downto 0));
end entity;

architecture parallel of and2 is
begin

    z <= x and y;

end architecture;
