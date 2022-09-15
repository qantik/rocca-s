library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity reg is
    generic (SIZE : integer);
    port (CLK : in  std_logic;
          en  : in  std_logic;
          D   : in  std_logic_vector((SIZE - 1) downto 0);
          Q   : out std_logic_vector((SIZE - 1) downto 0));
end;

architecture STRUCTURAL of reg is
begin

    process (CLK)
    begin 
        if rising_edge(CLK) then
            if en = '1' then
                Q <= D;
            end if;
        end if;
    end process;

end;
