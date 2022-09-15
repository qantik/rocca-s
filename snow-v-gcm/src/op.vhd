library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- contains conversion functions

entity op is
  
  port (
    a1,b1 : in  std_logic ;
    a2,b2 : in  std_logic ;
    o1,o2 : out std_logic
    );

end op;

architecture f of op is


begin

o1 <= a1 or (b1 and a2);

o2 <= b1 and b2;


end architecture f;
