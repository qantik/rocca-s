library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.all;


entity word_invert is 
generic (SIZE : integer);
port (
	InpxDI : in std_logic_vector (16*SIZE-1 downto 0);
    OupxDO : out std_logic_vector (16*SIZE-1 downto 0)
    );
end;



architecture ballif of word_invert is
begin 

    byte_sequence_inversion: for i in 0 to (SIZE-1) generate
        OupxDO(16*i+15 downto 16*i+8) <= InpxDI(16*i+7 downto 16*i);
        OupxDO(16*i+7 downto 16*i) <= InpxDI(16*i+15 downto 16*i+8);
    end generate;    

end;


