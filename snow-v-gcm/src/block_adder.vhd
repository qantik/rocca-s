library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity block_adder is
  port(
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        s: out std_logic_vector(31 downto 0)
      );
end;

architecture brentkung of block_adder is

    signal g,p      :  std_logic_vector(31 downto 0);
    signal l1g,l1p  :  std_logic_vector(15 downto 0);
    signal l2g,l2p  :  std_logic_vector(7 downto 0);
    signal l3g,l3p  :  std_logic_vector(3 downto 0);
    signal l4g,l4p  :  std_logic_vector(1 downto 0);


signal G2,G4,G5,G6, G8,G9,G10,G11, G12,G13,G14,G16, G17,G18,G19,G20, G21,G22,G23, G24, G25,G26,G27, G28,G29,G30,G31 :  std_logic;
signal P2,P4,P5,P6, P8,P9,P10,P11, P12,P13,P14,P16, P17,P18,P19,P20, P21,P22,P23, P24, P25,P26,P27, P28,P29,P30,P31 :  std_logic;


begin

a1: for i in 0 to 31 generate

g(i) <= a(i) and b(i);
p(i) <= a(i) xor b(i);

end generate a1;

--level 1

l1: for i in 0 to 15 generate

l1o: entity op (f) port map (g(2*i+1),p(2*i+1), g(2*i),p(2*i), l1g(i),l1p(i) ); 

end generate l1;

--level 2

l2: for i in 0 to 7 generate

l2o: entity op (f) port map (l1g(2*i+1),l1p(2*i+1), l1g(2*i),l1p(2*i), l2g(i),l2p(i) ); 

end generate l2;


--level 3

l3: for i in 0 to 3 generate

l3o: entity op (f) port map (l2g(2*i+1),l2p(2*i+1), l2g(2*i),l2p(2*i), l3g(i),l3p(i) ); 

end generate l3;

--level 4

l4: for i in 0 to 1 generate

l4o: entity op (f) port map (l3g(2*i+1),l3p(2*i+1), l3g(2*i),l3p(2*i), l4g(i),l4p(i) ); 

end generate l4;

--level 5

 

--l5o: entity op (f) port map (l4g(0),l4p(0), l4g(1),l4p(1), G,P) ); 

 



s(0) <= p(0);
s(1) <= p(1) xor g(0);
s(2) <= p(2) xor l1g(0);
G2   <= g(2) or (l1g(0) and p(2));-- l1g(0) or (g(2) and l1p(0));
s(3) <= p(3) xor G2;

s(4) <= p(4) xor l2g(0);
G4   <= g(4) or (l2g(0) and p(4));--l2g(0) or (g(4) and l2p(0));
s(5) <= p(5) xor G4;
G5   <= l1g(2) or (l2g(0) and l1p(2));--l2g(0) or (l1g(2) and l2p(0));
--P5   <= l2p(0) and l1p(2) ;
s(6) <= p(6) xor G5;
G6   <= g(6) or (G5 and p(6));-- G5 or (g(6) and P5);
s(7) <= p(7) xor G6;


s(8) <= p(8) xor l3g(0);
G8   <= g(8) or (l3g(0) and p(8)) ;--l3g(0) or (g(8) and l3p(0));4
s(9) <= p(9) xor G8;
G9   <= l1g(4) or (l3g(0) and l1p(4)) ;--l3g(0) or (l1g(4) and l3p(0));4
--P9   <= l3p(0) and l1p(4);
s(10)<= p(10) xor G9;
G10  <= g(10) or (G9 and p(10));--G9 or (g(10) and P9);5
s(11)<= p(11) xor G10;


G11  <= l2g(2) or (l3g(0) and l2p(2));--l3g(0) or (l2g(2) and l3p(0));4
--P11  <= (l2p(2) and l3p(0));
s(12)<= p(12) xor G11;
G12  <= g(12) or (G11 and p(12));--G11 or (g(12) and P11);5
s(13)<= p(13) xor G12;
G13  <= l1g(6) or (G11 and l1p(6));--G11 or (l1g(6) and P11);5
--P13  <= l1p(6) and P11;
s(14)<= p(14) xor G13;
G14  <= g(14) or (G13 and p(14));--G13 or (g(14) and P13);6
s(15)<= p(15) xor G14;



s(16) <= p(16) xor l4g(0);
G16   <= g(16) or (l4g(0) and p(16));--l4g(0) or (g(16) and l4p(0));5
s(17) <= p(17) xor G16;
G17   <= l1g(8) or (l4g(0) and l1p(8)); --l4g(0) or (l1g(8) and l4p(0));5
--P17   <= l4p(0) and l1p(8);
s(18) <= p(18) xor G17;
G18   <= g(18) or (G17 and p(18));--G17 or (g(18) and P17);6
s(19) <= p(19) xor G18;


G19   <= l2g(4) or (l4g(0) and l2p(4));--l4g(0) or (l2g(4) and l4p(0));5
--P19   <= l2p(4) and l4p(0);
s(20) <= p(20) xor G19;
G20   <= g(20) or (G19 and p(20));--G19 or (g(20) and P19);6
s(21) <= p(21) xor G20;
G21   <= l1g(10) or (G19 and l1p(10));--G19 or (l1g(10) and P19);6
--P21   <= l1p(10) and P19;
s(22) <= p(22) xor G21;
G22   <= g(22) or (G21 and p(22)) ; --G21 or (g(22) and P21);7
s(23) <= p(23) xor G22;


G23  <= l3g(2) or (l4g(0) and l3p(2));--l4g(0) or (l3g(2) and l4p(0));5
--P23  <= (l3p(2) and l4p(0));
s(24)<= p(24) xor G23;
G24  <= g(24) or (G23 and p(24));--G23 or (g(24) and P23);6
s(25)<= p(25) xor G24;
G25  <= l1g(12) or (G23 and l1p(12));--G23 or (l1g(12) and P23);6
--P25  <= l1p(12) and P23;
s(26)<= p(26) xor G25;
G26  <= g(26) or (G25 and p(26));--G25 or (g(26) and P25);7
s(27)<= p(27) xor G26;



G27  <= l2g(6) or (G23 and l2p(6));--G23 or (l2g(6) and P23);6
--P27  <= (l2p(6) and P23);
s(28)<= p(28) xor G27;
G28  <= g(28) or (G27 and p(28)); --G27 or (g(28) and P27);7
s(29)<= p(29) xor G28;
G29  <= l1g(14) or (G27 and l1p(14));--G27 or (l1g(14) and P27);7
--P29  <= l1p(14) and P27;
s(30)<= p(30) xor G29;
G30  <= g(30) or (G29 and p(30));--G29 or (g(30) and P29);8
s(31)<= p(31) xor G30;



end architecture brentkung;






