library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.all;

entity GF4_MUL_SCLw2 is
port ( AxDI, BxDI : in std_logic_vector (1 downto 0); 
       sAxDI, sBxDI: in std_logic;     
       CxDO : out std_logic_vector (1 downto 0) );
end entity GF4_MUL_SCLw2;

architecture gf4mulsclw2 of GF4_MUL_SCLw2 is 
signal TxD,SxD: std_logic;
begin

TxD <= sAxDI nand sBxDI;
SxD <= AxDI(0) nand BxDI(0);

CxDO(0) <=  (AxDI(1) nand BxDI(1)) xor SxD ;
CxDO(1) <=  SxD xor TxD ;
end architecture gf4mulsclw2;