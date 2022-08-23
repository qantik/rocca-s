library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.all;

entity GF4_MUL is
port ( AxDI, BxDI : in std_logic_vector (1 downto 0); 
       sAxDI, sBxDI: in std_logic;     
       CxDO : out std_logic_vector (1 downto 0) );
end entity GF4_MUL;

architecture gf4mul of GF4_MUL is 
signal TxD: std_logic;
begin

TxD <= sAxDI nand sBxDI;

CxDO(1) <=  (AxDI(1) nand BxDI(1)) xor TxD ;
CxDO(0) <=  (AxDI(0) nand BxDI(0)) xor TxD ;
end architecture gf4mul;