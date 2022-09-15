library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.all;



entity mixcolumns is 
port (
	InpxDI : in std_logic_vector (127 downto 0);
    OupxDO : out std_logic_vector (127 downto 0)
    );
end entity mixcolumns;



architecture dui of mixcolumns is
begin 

	msc0: entity mix_single_column (banik) port map (InpxDI(31 downto 0), OupxDO(31 downto 0));
	msc1: entity mix_single_column (banik) port map (InpxDI(63 downto 32), OupxDO(63 downto 32));
	msc2: entity mix_single_column (banik) port map (InpxDI(95 downto 64), OupxDO(95 downto 64));
	msc3: entity mix_single_column (banik) port map (InpxDI(127 downto 96), OupxDO(127 downto 96));

end architecture dui;


