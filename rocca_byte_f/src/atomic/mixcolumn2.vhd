library ieee;
use ieee.std_logic_1164.all;

entity mixcolumn2 is 
    port (mi : in  std_logic_vector (31 downto 0);
          mo : out std_logic_vector (31 downto 0));
end entity;

architecture parallel of mixcolumn2 is

    signal x : std_logic_vector(31 downto 0);
    signal y : std_logic_vector(31 downto 0);
    signal t : std_logic_vector(59 downto 0);

begin

    x(7 downto 0)   <= mi(31 downto 24);
    x(15 downto 8)  <= mi(23 downto 16);
    x(23 downto 16) <= mi(15 downto 8);
    x(31 downto 24) <= mi(7  downto 0);

    t(0)  <= x(0)  xor x(8);   -- t0 = x0 ^ x8
    t(1)  <= x(16) xor x(24);  -- t1 = x16 ^ x24
    t(2)  <= x(1)  xor x(9);   -- t2 = x1 ^ x9
    t(3)  <= x(17) xor x(25);  -- t3 = x17 ^ x25
    t(4)  <= x(2)  xor x(10);  -- t4 = x2 ^ x10
    t(5)  <= x(18) xor x(26);  -- t5 = x18 ^ x26
    t(6)  <= x(3)  xor x(11);  -- t6 = x3 ^ x11
    t(7)  <= x(19) xor x(27);  -- t7 = x19 ^ x27
    t(8)  <= x(4)  xor x(12);  -- t8 = x4 ^ x12
    t(9)  <= x(20) xor x(28);  -- t9 = x20 ^ x28
    t(10) <= x(5)  xor x(13);  -- t10 = x5 ^ x13
    t(11) <= x(21) xor x(29);  -- t11 = x21 ^ x29
    t(12) <= x(6)  xor x(14);  -- t12 = x6 ^ x14
    t(13) <= x(22) xor x(30);  -- t13 = x22 ^ x30
    t(14) <= x(23) xor x(31);  -- t14 = x23 ^ x31
    t(15) <= x(7)  xor x(15);  -- t15 = x7 ^ x15
    t(16) <= x(8)  xor t(1);   -- t16 = x8 ^ t1
    y(0)  <= t(15) xor t(16);  -- y0 = t15 ^ t16
    t(17) <= x(7)  xor x(23);  -- t17 = x7 ^ x23
   
    t(18) <= x(24) xor t(0);   -- t18 = x24 ^ t0
    y(16) <= t(14) xor t(18);  -- y16 = t14 ^ t18
    t(19) <= t(1)  xor y(16);  -- t19 = t1 ^ y16
    y(24) <= t(17) xor t(19);  -- y24 = t17 ^ t19
    t(20) <= x(27) xor t(14);  -- t20 = x27 ^ t14
    t(21) <= t(0)  xor y(0);   -- t21 = t0 ^ y0
    y(8)  <= t(17) xor t(21);  -- y8 = t17 ^ t21
    t(22) <= t(5)  xor t(20);  -- t22 = t5 ^ t20
    y(19) <= t(6)  xor t(22);  -- y19 = t6 ^ t22
    t(23) <= x(11) xor t(15);  -- t23 = x11 ^ t15
    t(24) <= t(7)  xor t(23);  -- t24 = t7 ^ t23
    y(3)  <= t(4)  xor t(24);  -- y3 = t4 ^ t24
    t(25) <= x(2)  xor x(18);  -- t25 = x2 ^ x18
    t(26) <= t(17) xor t(25);  -- t26 = t17 ^ t25
    t(27) <= t(9)  xor t(23);  -- t27 = t9 ^ t23
    t(28) <= t(8)  xor t(20);  -- t28 = t8 ^ t20
    t(29) <= x(10) xor t(2);   -- t29 = x10 ^ t2
    y(2)  <= t(5)  xor t(29);  -- y2 = t5 ^ t29
    t(30) <= x(26) xor t(3);   -- t30 = x26 ^ t3

    y(18) <= t(4)  xor t(30);  -- y18 = t4 ^ t30
    t(31) <= x(9)  xor x(25);  -- t31 = x9 ^ x25
    t(32) <= t(25) xor t(31);  -- t32 = t25 ^ t31
    y(10) <= t(30) xor t(32);  -- y10 = t30 ^ t32
    y(26) <= t(29) xor t(32);  -- y26 = t29 ^ t32
    t(33) <= x(1)  xor t(18);  -- t33 = x1 ^ t18
    t(34) <= x(30) xor t(11);  -- t34 = x30 ^ t11
    y(22) <= t(12) xor t(34);  -- y22 = t12 ^ t34
    t(35) <= x(14) xor t(13);  -- t35 = x14 ^ t13
    y(6)  <= t(10) xor t(35);  -- y6 = t10 ^ t35
    t(36) <= x(5)  xor x(21);  -- t36 = x5 ^ x21
    t(37) <= x(30) xor t(17);  -- t37 = x30 ^ t17
    t(38) <= x(17) xor t(16);  -- t38 = x17 ^ t16
    t(39) <= x(13) xor t(8);   -- t39 = x13 ^ t8
    y(5)  <= t(11) xor t(39);  -- y5 = t11 ^ t39
    t(40) <= x(12) xor t(36);  -- t40 = x12 ^ t36
    t(41) <= x(29) xor t(9);   -- t41 = x29 ^ t9
    y(21) <= t(10) xor t(41);  -- y21 = t10 ^ t41
    t(42) <= x(28) xor t(40);  -- t42 = x28 ^ t40

    y(13) <= t(41) xor t(42);  -- y13 = t41 ^ t42
    y(29) <= t(39) xor t(42);  -- y29 = t39 ^ t42
    t(43) <= x(15) xor t(12);  -- t43 = x15 ^ t12
    y(7)  <= t(14) xor t(43);  -- y7 = t14 ^ t43
    t(44) <= x(14) xor t(37);  -- t44 = x14 ^ t37
    y(31) <= t(43) xor t(44);  -- y31 = t43 ^ t44
    t(45) <= x(31) xor t(13);  -- t45 = x31 ^ t13
    y(15) <= t(44) xor t(45);  -- y15 = t44 ^ t45
    y(23) <= t(15) xor t(45);  -- y23 = t15 ^ t45
    t(46) <= t(12) xor t(36);  -- t46 = t12 ^ t36
    y(14) <= y(6)  xor t(46);  -- y14 = y6 ^ t46
    t(47) <= t(31) xor t(33);  -- t47 = t31 ^ t33
    y(17) <= t(19) xor t(47);  -- y17 = t19 ^ t47
    t(48) <= t(6)  xor y(3);   -- t48 = t6 ^ y3
    y(11) <= t(26) xor t(48);  -- y11 = t26 ^ t48
    t(49) <= t(2)  xor t(38);  -- t49 = t2 ^ t38
    y(25) <= y(24) xor t(49);  -- y25 = y24 ^ t49
    t(50) <= t(7)  xor y(19);  -- t50 = t7 ^ y19
    y(27) <= t(26) xor t(50);  -- y27 = t26 ^ t50

    t(51) <= x(22) xor t(46);  -- t51 = x22 ^ t46
    y(30) <= t(11) xor t(51);  -- y30 = t11 ^ t51
    t(52) <= x(19) xor t(28);  -- t52 = x19 ^ t28
    y(20) <= x(28) xor t(52);  -- y20 = x28 ^ t52
    t(53) <= x(3)  xor t(27);  -- t53 = x3 ^ t27
    y(4)  <= x(12) xor t(53);  -- y4 = x12 ^ t53
    t(54) <= t(3)  xor t(33);  -- t54 = t3 ^ t33
    y(9)  <= y(8)  xor t(54);  -- y9 = y8 ^ t54
    t(55) <= t(21) xor t(31);  -- t55 = t21 ^ t31
    y(1)  <= t(38) xor t(55);  -- y1 = t38 ^ t55
    t(56) <= x(4)  xor t(17);  -- t56 = x4 ^ t17
    t(57) <= x(19) xor t(56);  -- t57 = x19 ^ t56
    y(12) <= t(27) xor t(57);  -- y12 = t27 ^ t57
    t(58) <= x(3)  xor t(28);  -- t58 = x3 ^ t28
    t(59) <= t(17) xor t(58);  -- t59 = t17 ^ t58
    y(28) <= x(20) xor t(59);  -- y28 = x20 ^ t59

    mo(7 downto 0)   <= y(31 downto 24);
    mo(15 downto 8)  <= y(23 downto 16);
    mo(23 downto 16) <= y(15 downto 8);
    mo(31 downto 24) <= y(7  downto 0);

end architecture;
