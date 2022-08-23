library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.all;

entity GF256_INV is
port ( AxDI : in std_logic_vector (7 downto 0); QxDO : out std_logic_vector (7 downto 0) );
end entity GF256_INV;

architecture gf256inv of GF256_INV is 
-- AxDI = A d^16 + B d
-- A = Ah z^4 + Al z ,  B = Bh z^4+ Bl z


signal sA32xD,sB32xD,sA10xD,sB10xD, sAxD,sBxD: std_logic;

signal AhlxD, BhlxD: std_logic_vector (1 downto 0);

signal C1xD,C2xD,C3xD: std_logic;

signal CxD,DxD: std_logic_vector (3 downto 0);

signal sD32xD,sD10xD,sDxD: std_logic;

signal DhlxD: std_logic_vector (1 downto 0);
 
begin

AhlxD(1) <= AxDI(7) xor AxDI(5);
AhlxD(0) <= AxDI(6) xor AxDI(4);

BhlxD(1) <= AxDI(3) xor AxDI(1);
BhlxD(0) <= AxDI(2) xor AxDI(0);

sAxD <= AhlxD(1) xor AhlxD(0);
sBxD <= BhlxD(1) xor BhlxD(0);


sA32xD <= AxDI(7) xor AxDI(6);
sA10xD <= AxDI(5) xor AxDI(4);

sB32xD <= AxDI(3) xor AxDI(2);
sB10xD <= AxDI(1) xor AxDI(0);

C1xD <= sA32xD nand sB32xD;
C2xD <= AhlxD(0) nand BhlxD(0);
C3xD <= sAxD nand sBxD ;

CxD(3) <= (AhlxD(0) nor BhlxD(0)) xor (AxDI(7) nand AxDI(3)) xor C1xD xor C3xD;
CxD(2) <= (AhlxD(1) nor BhlxD(1)) xor (AxDI(6) nand AxDI(2)) xor C1xD xor C2xD; 

CxD(1) <= (sA10xD nor sB10xD) xor (AxDI(5) nand AxDI(1)) xor C3xD xor C2xD; 
CxD(0) <= (sA10xD nand sB10xD) xor (AxDI(4) nor AxDI(0)) xor (AhlxD(1) nand BhlxD(1)) xor C2xD; 

--

gf16inv01: entity GF16_INV (gf16inv) port map (CxD, DxD);

 
DhlxD(1) <= DxD(3) xor DxD(1);
DhlxD(0) <= DxD(2) xor DxD(0);
sD32xD <= DxD(3) xor DxD(2);
sD10xD <= DxD(1) xor DxD(0);
sDxD <= DhlxD(1) xor DhlxD(0);

gf16mul01: entity GF16_MUL (gf16mul) port map (DxD,AxDI(3 downto 0), DhlxD,BhlxD, sD32xD,sD10xD,sB32xD,sB10xD,sDxD,sBxD, QxDO(7 downto 4));

gf16mul02: entity GF16_MUL (gf16mul) port map (DxD,AxDI(7 downto 4), DhlxD,AhlxD, sD32xD,sD10xD,sA32xD,sA10xD,sDxD,sAxD, QxDO(3 downto 0));



end architecture gf256inv;