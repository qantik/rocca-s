library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.all;


entity SBOX is
port ( AxDI : in std_logic_vector (7 downto 0); 
SxDO : out std_logic_vector (7 downto 0));
end entity SBOX;

architecture aessbox of SBOX is 
signal BxD,CxD,YxD,ZxD,DxD,XxD : std_logic_vector (7 downto 0);
signal RxD : std_logic_vector (9 downto 1);
signal TxD : std_logic_vector (10 downto 1); 

begin

RxD(1) <= AxDI(7) xor AxDI(5);
RxD(2) <= AxDI(7) xor AxDI(4);
RxD(3) <= AxDI(6) xor AxDI(0);
RxD(4) <= AxDI(5) xor RxD(3);
RxD(5) <= AxDI(4) xor RxD(4);
RxD(6) <= AxDI(3) xor AxDI(0);
RxD(7) <= AxDI(2) xnor RxD(1);
RxD(8) <= AxDI(1) xor RxD(3);
RxD(9) <= AxDI(3) xnor RxD(8);

BxD(7) <= RxD(7) xnor RxD(8);
BxD(6) <= RxD(5);
BxD(5) <= AxDI(1) xor RxD(4);
BxD(4) <= RxD(1) xor RxD(3);
BxD(3) <= AxDI(1) xor RxD(2) xor RxD(6);
BxD(2) <= AxDI(0);
BxD(1) <= RxD(4);
BxD(0) <= AxDI(2) xnor RxD(9);

ZxD <= BxD;


gf256inv01: entity GF256_INV (gf256inv) port map (ZxD,CxD);



TxD(1) <= CxD(7) xnor CxD(3);
TxD(2) <= CxD(6) xor CxD(4);
TxD(3) <= CxD(6) xnor CxD(0);
TxD(4) <= CxD(5) xor CxD(3);
TxD(5) <= CxD(5) xnor TxD(1);
TxD(6) <= CxD(5) xnor CxD(1);
TxD(7) <= CxD(4) xor TxD(6);
TxD(8) <= CxD(2) xnor TxD(4);
TxD(9) <= CxD(1) xnor TxD(2);
TxD(10)<= TxD(3) xor TxD(5);

DxD(7) <= TxD(4);
DxD(6) <= TxD(1);
DxD(5) <= TxD(3);
DxD(4) <= TxD(5);
DxD(3) <= TxD(2) xor TxD(5);
DxD(2) <= TxD(3) xor TxD(8);
DxD(1) <= TxD(7);
DxD(0) <= TxD(9);

SxDO <= DxD;
end architecture aessbox;


--SELECT_NOT_8 sel_in( B, Y, encrypt, Z );
--GF_INV_8 inv( Z, C );
--/* change basis back from GF(2^8)/GF(2^4)/GF(2^2) to GF(2^8) */
--assign T1 = C[7] ^ C[3] ;+
--assign T2 = C[6] ^ C[4] ;=
--assign T3 = C[6] ^ C[0] ;+
--assign T4 = C[5] ~^ C[3] ;+
--assign T5 = C[5] ~^ T1 ;+
--assign T6 = C[5] ~^ C[1];=
--assign T7 = C[4] ~^ T6 ;+
--assign T8 = C[2] ^ T4 ;=
--assign T9 = C[1] ^ T2 ;+
--assign T10 = T3 ^ T5 ;=
--assign D[7] = T4 ;+
--assign D[6] = T1 ;+
--assign D[5] = T3 ;+
--assign D[4] = T5 ;+
--assign D[3] = T2 ^ T5 ;+
--assign D[2] = T3 ^ T8 ;+
--assign D[1] = T7 ;+
--assign D[0] = T9 ;+
--assign X[7] = C[4] ~^ C[1] ;+
--assign X[6] = C[1] ^ T10 ;+
--assign X[5] = C[2] ^ T10 ;
--assign X[4] = C[6] ~^ C[1] ;
--assign X[3] = T8 ^ T9 ;
--assign X[2] = C[7] ~^ T7 ;
--assign X[1] = T6 ;
--assign X[0] = ~ C[2] ;
--SELECT_NOT_8 sel_out( D, X, encrypt, Q );
