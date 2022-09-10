library ieee;
use ieee.std_logic_1164.all;

entity taux_reg is
    port (clk     : in std_logic;
          reset_n : in std_logic;

          load : in std_logic;
          d    : in std_logic_vector(127 downto 0);
          q    : out std_logic_vector(127 downto 0));
end entity;

architecture behavioural of taux_reg is
begin

    reg : process(clk, reset_n)
    begin
        if reset_n = '0' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                q <= d;
            end if;
        end if;
    end process;

end architecture;
