library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity controller is
  generic(R : integer);
  port(
        CLK : in std_logic;
        RST : in std_logic;
        addKeyLeft : out std_logic_vector(R downto 1);
        addKeyRight : out std_logic_vector(R downto 1);
        init : out std_logic_vector(R downto 1);
        load : out std_logic
      );
end;


architecture ballif of controller is

    signal counter_p, counter_n : integer range 0 to 31;
begin

    process (RST, CLK) 
    begin
        if RST ='0' then
            counter_p <= 0;
        elsif CLK'event and CLK = '1' then
            counter_p <= counter_n;
        end if;
    end process;
    

    controlloop: for i in 1 to R generate
        init(i) <= '1' when 17 > R*(counter_p-1) + i  else '0';
        addKeyLeft(i) <= '1' when R*(counter_p-1) + i  = 15 else '0';
        addKeyRight(i) <= '1' when R*(counter_p-1) + i  = 16 else '0';
    end generate;
    
    counter_n <= counter_p + 1 when counter_p < 17 else 17;
    
    
    --addKeyLeft <= '1' when counter_p = 15 else '0';
    --addKeyRight <= '1' when counter_p = 16 else '0';
    
    load <= '1' when counter_p = 0 else '0';
    --init <= '1' when counter_p < 17 else '0';
end architecture ballif;

