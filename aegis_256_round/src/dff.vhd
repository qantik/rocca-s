library ieee;
use ieee.std_logic_1164.all;

entity dff is
    port (clk     : in std_logic;
          reset_n : in std_logic;

          load : in std_logic;
          d0   : in std_logic;
          d1   : in std_logic;
          q    : out std_logic);
end entity;

architecture behavioural of dff is
begin

    flipflop : process(clk, reset_n)
    begin
        if reset_n = '0' then
            q <= '0';
        elsif rising_edge(clk) then
            if load = '1' then
                q <= d0;
            else
                q <= d1;
            end if;
        end if;
    end process;

end architecture;
