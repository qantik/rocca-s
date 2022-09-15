library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity fr1 is
  port(
        A : in std_logic_vector(255 downto 0);
        KEY : in std_logic_vector(255 downto 0);
        R2 : in std_logic_vector(127 downto 0);
        R3 : in std_logic_vector(127 downto 0);
        addKeyLeft : in std_logic;
        addKeyRight: in std_logic;
        R1n : out std_logic_vector(127 downto 0)
      );
end;


architecture ballif of fr1 is
    signal tmp1, tmp2, tmp3 : std_logic_vector(127 downto 0);
begin

    tmp1 <= R3 xor A(127 downto 0);
    wadder0 : entity word_adder port map (tmp1, R2, tmp2);
    sigma0: entity sigma port map (tmp2, tmp3);
    
    process (addKeyLeft, addKeyRight, KEY, tmp3)
    begin
        if addKeyLeft = '1' then
            R1n <= tmp3 xor KEY(127 downto 0);
        elsif addKeyRight = '1' then
            R1n <= tmp3 xor KEY(255 downto 128);        
        else
            R1n <= tmp3;
        end if;        
    end process;
    
end architecture ballif;

