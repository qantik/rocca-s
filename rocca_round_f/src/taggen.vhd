library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.rocca_round_f_pkg.all;

entity taggen is
    port (s   : in  state_t_arr;
          tag : out std_logic_vector(255 downto 0));
end entity;

architecture parallel of taggen is
begin

    tag <= (s(0) xor s(1) xor s(2) xor s(3)) & (s(4) xor s(5) xor s(6));

end architecture;

