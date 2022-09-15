library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity byte_adder is
  port(
        a: in std_logic_vector(7 downto 0);
        b: in std_logic_vector(7 downto 0);
        cin: in std_logic;
        s: out std_logic_vector(7 downto 0);
        cout:  out std_logic
      );
end;

architecture brentkung of byte_adder is

    signal c ,c0,c1      :  std_logic_vector(1 downto 0);
 
    signal  s0,s1  :  std_logic_vector(7 downto 0);

 
begin

 
a1:  entity nibble_adder (brentkung) port map (a(3 downto 0), b(3 downto 0), cin, s(3 downto 0),c(0) );

a21: entity nibble_adder (brentkung) port map (a(7 downto 4), b(7 downto 4), '0', s0(7 downto 4),c0(1) );
a22: entity nibble_adder (brentkung) port map (a(7 downto 4), b(7 downto 4), '1', s1(7 downto 4),c1(1) );
 
 
s(7 downto 4) <= s0(7 downto 4) when c(0) = '0' else s1(7 downto 4);
cout <= c0(1) when c(0) = '0' else c1(1);

end architecture brentkung;






