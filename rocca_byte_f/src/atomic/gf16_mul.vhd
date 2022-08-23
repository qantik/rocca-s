library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.all;

entity GF16_MUL is
port ( AxDI,BxDI: in std_logic_vector (3 downto 0); 
       AhlxDI, BhlxDI: in std_logic_vector (1 downto 0);
       sA32xDI, sA10xDI, sB32xDI, sB10xDI: in std_logic;
       sAxDI, sBxDI: in std_logic;
       CxDO : out std_logic_vector (3 downto 0) );
end entity GF16_MUL;

architecture gf16mul of GF16_MUL is 
signal PhxD,PlxD,PxD: std_logic_vector (1 downto 0);
begin
gf4mul01: entity GF4_MUL (gf4mul) port map (AxDI(3 downto 2), BxDI(3 downto 2), sA32xDI,sB32xDI, PhxD);
gf4mul02: entity GF4_MUL (gf4mul) port map (AxDI(1 downto 0), BxDI(1 downto 0), sA10xDI,sB10xDI, PlxD);

gf4mulsc01: entity GF4_MUL_SCLw2 (gf4mulsclw2) port map (AhlxDI,BhlxDI, sAxDI,sBxdI,PxD);

CxDO(3) <= PhxD(1) xor PxD(1);
CxDO(2) <= PhxD(0) xor PxD(0);

CxDO(1) <= PlxD(1) xor PxD(1);
CxDO(0) <= PlxD(0) xor PxD(0);

end architecture gf16mul;