library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity word_adder is
  port(
        X: in std_logic_vector(127 downto 0);
        Y: in std_logic_vector(127 downto 0);
        Z: out std_logic_vector(127 downto 0)
      );
end;


architecture ballif of word_adder is

    signal x1, x2, x3, x4 : std_logic_vector(31 downto 0);
    signal y1, y2, y3, y4 : std_logic_vector(31 downto 0);
    signal z1, z2, z3, z4 : std_logic_vector(31 downto 0);

begin

    x1 <=  (X(31 downto 0));
    x2 <=  (X(63 downto 32));
    x3 <=  (X(95 downto 64));
    x4 <=  (X(127 downto 96));
    y1 <=  (Y(31 downto 0));
    y2 <=  (Y(63 downto 32));
    y3 <=  (Y(95 downto 64));
    y4 <=  (Y(127 downto 96));

    ba1: entity  adder (kogstone) port map (x1,y1,z1);--z1 <= x1 + y1;
    ba2: entity  adder (kogstone) port map (x2,y2,z2);--z2 <= x2 + y2;
    ba3: entity  adder (kogstone) port map (x3,y3,z3);--z3 <= x3 + y3;
    ba4: entity  adder (kogstone) port map (x4,y4,z4);--z4 <= x4 + y4;

    Z(31 downto 0) <=   (z1);
    Z(63 downto 32) <=  (z2);
    Z(95 downto 64) <=  (z3);
    Z(127 downto 96) <= (z4);
		
end architecture ballif;

