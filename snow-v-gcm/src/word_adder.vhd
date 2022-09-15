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

    signal x1, x2, x3, x4 : unsigned(31 downto 0);
    signal y1, y2, y3, y4 : unsigned(31 downto 0);
    signal z1, z2, z3, z4 : unsigned(31 downto 0);

begin

    x1 <= unsigned(X(31 downto 0));
    x2 <= unsigned(X(63 downto 32));
    x3 <= unsigned(X(95 downto 64));
    x4 <= unsigned(X(127 downto 96));
    y1 <= unsigned(Y(31 downto 0));
    y2 <= unsigned(Y(63 downto 32));
    y3 <= unsigned(Y(95 downto 64));
    y4 <= unsigned(Y(127 downto 96));

    z1 <= x1 + y1;
    z2 <= x2 + y2;
    z3 <= x3 + y3;
    z4 <= x4 + y4;

    Z(31 downto 0) <= std_logic_vector(z1);
    Z(63 downto 32) <= std_logic_vector(z2);
    Z(95 downto 64) <= std_logic_vector(z3);
    Z(127 downto 96) <= std_logic_vector(z4);
		
end architecture ballif;

