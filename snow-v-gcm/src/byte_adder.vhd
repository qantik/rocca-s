library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity byte_adder is
  port(
        a: in std_logic_vector(7 downto 0);
        b: in std_logic_vector(7 downto 0);
        c: in std_logic;
        s: out std_logic_vector(7 downto 0);
        cout:  out std_logic
      );
end;

architecture brentkung of byte_adder is

    signal g,p      :  std_logic_vector(7 downto 0);
    signal LG       :  std_logic_vector(7 downto 0);
 

 
begin

a1: for i in 0 to 7 generate

g(i) <= a(i) and b(i);
p(i) <= a(i) xor b(i);

end generate a1;
 

 
LG(0) <= g(0) or (c  and p(0));
b1: for i in 1 to 7 generate
 LG(i) <= g(i) or (LG(i-1)  and p(i));
end generate b1;


s(0) <= p(0) xor c;
 c1: for i in 1 to 7 generate
 s(i) <= p(i)  xor LG(i-1);
end generate c1;

cout<= LG(7);
end architecture brentkung;






