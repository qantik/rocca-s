library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.all;


entity byte_invert is 
port (
	InpxDI : in std_logic_vector (127 downto 0);
    OupxDO : out std_logic_vector (127 downto 0)
    );
end;



architecture ballif of byte_invert is
begin 

    byte_sequence_inversion: for i in 0 to 15 generate
        OupxDO(8*i+7 downto 8*i) <= InpxDI(8*(15-i)+7 downto 8*(15-i));
    end generate;    

end;


