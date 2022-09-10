library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

entity state_reg is
    generic (size : integer := 128);
    port (clk     : in std_logic;
          reset_n : in std_logic;
         
          load : in std_logic;
          d0   : in std_logic_vector(size-1 downto 0);
          d1   : in std_logic_vector(size-1 downto 0);
          q : out std_logic_vector(size-1 downto 0));
end entity;

architecture structural of state_reg is
begin

    bank : for i in 0 to size-1 generate
        dff_gen : entity dff port map (clk, reset_n, load, d0(i), d1(i), q(i));
    end generate;

end architecture;

