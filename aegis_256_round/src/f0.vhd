library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.aegis256_round_pkg.all;

entity f0 is
    port (s  : in  state_t_arr;
          m  : in  std_logic_vector(127 downto 0);
          ct : out std_logic_vector(127 downto 0));
end entity;

architecture parallel of f0 is
begin

    ct <= m xor s(1) xor s(4) xor s(5) xor (s(2) and s(3));

end architecture;

