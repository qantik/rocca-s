library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.all;

entity GF16_INV is
port ( AxDI: in std_logic_vector (3 downto 0); 
       BxDO : out std_logic_vector (3 downto 0) );
end entity GF16_INV;

architecture gf16inv of GF16_INV is 
signal sA32xD, sA10xD: std_logic;
signal ThetaxD : std_logic_vector (1 downto 0);
signal sThetaxD: std_logic;
begin
sA32xD <= AxDI(3) xor AxDI(2);
sA10xD <= AxDI(1) xor AxDI(0);

ThetaxD(0) <=  ( AxDI(3) nor AxDI(1) ) xor (sA32xD nand sA10xD) ;
ThetaxD(1) <=  ( AxDI(2) nand AxDI(0) ) xor (sA32xD nor sA10xD) ;

sThetaxD <= ThetaxD(0) xor ThetaxD(1);

Gf4m_01: entity GF4_MUL (gf4mul) port map (ThetaxD, AxDI(1 downto 0), sThetaxD, sA10xD, BxDO(3 downto 2)   );
Gf4m_02: entity GF4_MUL (gf4mul) port map (ThetaxD, AxDI(3 downto 2), sThetaxD, sA32xD, BxDO(1 downto 0)   );

end architecture gf16inv;