library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.all;
 

entity sbox128 is
port ( InpxDI : in  std_logic_vector(127 downto 0);
      OupxDO : out std_logic_vector(127 downto 0));
end entity sbox128;

architecture DaE of sbox128 is 
begin

	boxes: for i in 0 to 15 generate
		sbi: entity SBOX (ballif) port map (InpxDI((8*i+7) downto (8*i)), OupxDO((8*i+7) downto (8*i)));
	end generate boxes;


end architecture DaE;



  
