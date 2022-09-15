   
library work;
use work.all;
	
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;	


entity adder is
port(
        A    : in  std_logic_vector(31 downto 0);
        B    : in  std_logic_vector(31 downto 0);
        S     : out std_logic_vector(31 downto 0) 
 
    );

end adder;

architecture kogstone of adder is
 
signal P0,P1,P2,P3,P4,G0,G1,G2,G3,G4,G5: std_logic_vector(31 downto 0);

begin


a0: for i in 0 to 31 generate 

P0(i)<=  A(i)  xor  B(i);
G0(i)<=  A(i)  and  B(i);

end generate a0;

G1(0)<= G0(0);
P1(0)<= not P0(0);

a1: for i in 1 to 31 generate 

P1(i)<=  P0(i)  and  P0(i-1);
G1(i)<=  G0(i)  or   (P0(i) and G0(i-1));

end generate a1;

G2(1 downto 0)<= G1(1 downto 0);
P2(1 downto 0)<= P1(1 downto 0) xor "11" ;
 

a2: for i in 2 to 31 generate 

P2(i)<=  P1(i)  and  P1(i-2);
G2(i)<=  G1(i)  or   (P1(i) and G1(i-2));

end generate a2;

G3(3 downto 0)<= G2(3 downto 0);
P3(3 downto 0)<= P2(3 downto 0) xor x"f";

a3: for i in 4 to 31 generate 

P3(i)<=  P2(i)  and  P2(i-4);
G3(i)<=  G2(i)  or   (P2(i) and G2(i-4));

end generate a3;

G4(7 downto 0)<= G3(7 downto 0);
P4(7 downto 0)<= P3(7 downto 0) xor x"ff";

a4: for i in 8 to 31 generate 

P4(i)<=  P3(i)  and  P3(i-8);
G4(i)<=  G3(i)  or   (P3(i) and G3(i-8));

end generate a4;

G5(15 downto 0)<= G4(15 downto 0);

a5: for i in 16 to 31 generate 
 
G5(i)<=  G4(i)  or   (P4(i) and G4(i-8));

end generate a5;
 
S(0)<=P0(0);
sum: for i in 1 to 31 generate 
 
S(i)<=  P0(i)  xor  G5(i-1);

end generate sum;    

 


end architecture kogstone;
