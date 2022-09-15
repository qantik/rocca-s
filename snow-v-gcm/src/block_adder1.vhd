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

    signal  s0,s1      :  std_logic_vector(31 downto 0);
  
    signal c,c0,c1      :  std_logic_vector(3 downto 0);

 	

begin

a0: entity byte_adder (brentkung) port map (a(7 downto 0), b(7 downto 0), '0', s(7 downto 0),c(0) );


a1: entity byte_adder (brentkung) port map (a(15 downto 8), b(15 downto 8), '0', s0(15 downto 8),c0(1) );
b1: entity byte_adder (brentkung) port map (a(15 downto 8), b(15 downto 8), '1', s1(15 downto 8),c1(1) );

a2: entity byte_adder (brentkung) port map (a(23 downto 16), b(23 downto 16), '0', s0(23 downto 16),c0(2) );
b2: entity byte_adder (brentkung) port map (a(23 downto 16), b(23 downto 16), '1', s1(23 downto 16),c1(2) );


a3: entity byte_adder (brentkung) port map (a(31 downto 24), b(31 downto 24), '0', s0(31 downto 24),c0(3) );
b3: entity byte_adder (brentkung) port map (a(31 downto 24), b(31 downto 24), '1', s1(31 downto 24),c1(3) );



s(15 downto 8) <= s0(15 downto 8) when c(0) = '0' else s1(15 downto 8);
c(1) <= c0(1) when c(0) = '0' else c1(1);


s(23 downto 16) <= s0(23 downto 16) when c(1) = '0' else s1(23 downto 16);
c(2) <= c0(2) when c(1) = '0' else c1(2);

s(31 downto 24) <= s0(31 downto 24) when c(2) = '0' else s1(31 downto 24);
 

end architecture brentkung;






