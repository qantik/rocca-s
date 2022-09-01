library ieee;
use ieee.std_logic_1164.all;

entity invmixcolumn is 
    port (mi : in  std_logic_vector (31 downto 0);
          mo : out std_logic_vector (31 downto 0));
end entity;

architecture parallel of invmixcolumn is

    signal u      : std_logic_vector(31 downto 0);
    signal uu     : std_logic_vector(31 downto 0);
    signal uuu    : std_logic_vector(31 downto 0);
    signal uuuu   : std_logic_vector(31 downto 0);
    signal uuuuu  : std_logic_vector(31 downto 0);
    signal uuuuuu : std_logic_vector(31 downto 0);
    signal v      : std_logic_vector(31 downto 0);
    --signal y : std_logic_vector(31 downto 0);
    --signal t : std_logic_vector(59 downto 0);

begin
    
    u(7 downto 0)   <= mi(31 downto 24);
    u(15 downto 8)  <= mi(23 downto 16);
    u(23 downto 16) <= mi(15 downto 8);
    u(31 downto 24) <= mi(7  downto 0);

    uu(27)    <= u(27)    xor u(3);      -- 0:  u27=u27+u3
    uu(1)     <= u(1)     xor u(24);     -- 1:  u1=u1+u24
    uu(30)    <= u(30)    xor u(22);     -- 2:  u30=u30+u22
    uu(26)    <= u(26)    xor u(10);     -- 3:  u26=u26+u10
    uu(31)    <= u(31)    xor u(23);     -- 4:  u31=u31+u23
    uu(9)     <= u(9)     xor uu(1);     -- 5:  u9=u9+u1
    uu(22)    <= u(22)    xor u(6);      -- 6:  u22=u22+u6
    uu(15)    <= u(15)    xor uu(31);    -- 7:  u15=u15+u31
    uu(7)     <= u(7)     xor uu(15);    -- 8:  u7=u7+u15
    uu(17)    <= u(17)    xor uu(9);     -- 9:  u17=u17+u9
    uu(18)    <= u(18)    xor uu(26);    -- 10: u18=u18+u26
    uu(25)    <= u(25)    xor u(24);     -- 11: u25=u25+u24
    uu(24)    <= u(24)    xor u(0);      -- 12: u24=u24+u0
    uuu(25)   <= uu(25)   xor uu(17);    -- 13: u25=u25+u17
    uu(11)    <= u(11)    xor uu(27);    -- 14: u11=u11+u27
    uu(19)    <= u(19)    xor uu(11);    -- 15: u19=u19+u11
    uu(4)     <= u(4)     xor u(28);     -- 16: u4=u4+u28
    uu(6)     <= u(6)     xor u(14);     -- 17: u6=u6+u14
    uuu(26)   <= uu(26)   xor uuu(25);   -- 18: u26=u26+u25
    uu(12)    <= u(12)    xor uu(4);     -- 19: u12=u12+u4
    uu(20)    <= u(20)    xor uu(12);    -- 20: u20=u20+u12
    uuu(27)   <= uu(27)   xor uuu(26);   -- 21: u27=u27+u26
    uu(28)    <= u(28)    xor uuu(27);   -- 22: u28=u28+u27
    uu(21)    <= u(21)    xor u(5);      -- 23: u21=u21+u5
    uu(13)    <= u(13)    xor uu(21);    -- 24: u13=u13+u21
    uuu(21)   <= uu(21)   xor uu(20);    -- 25: u21=u21+u20
    uu(29)    <= u(29)    xor uu(13);    -- 26: u29=u29+u13
    uuu(30)   <= uu(30)   xor uuu(21);   -- 27: u30=u30+u21
    uuu(22)   <= uu(22)   xor uu(29);    -- 28: u22=u22+u29
    uuu(6)    <= uu(6)    xor uuu(21);   -- 29: u6=u6+u21
    uuu(15)   <= uu(15)   xor uuu(6);    v(7) <= uuu(15); -- 30: u15=u15+u6[v7]

    uu(14)    <= u(14)    xor uuu(22);   -- 31: u14=u14+u22
    uu(23)    <= u(23)    xor uuu(30);   -- 32: u23=u23+u30
    uuu(23)   <= uu(23)   xor uuu(15);   -- 33: u23=u23+u15
    uuu(31)   <= uu(31)   xor uuu(22);   -- 34: u31=u31+u22
    uu(8)     <= u(8)     xor uuu(31);   -- 35: u8=u8+u31
    uuu(24)   <= uu(24)   xor uuu(23);   -- 36: u24=u24+u23
    uuu(8)    <= uu(8)    xor uuu(24);   -- 37: u8=u8+u24
    uuu(1)    <= uu(1)    xor uuu(8);    -- 38: u1=u1+u8
    uuu(7)    <= uu(7)    xor uuu(31);   -- 39: u7=u7+u31
    uu(16)    <= u(16)    xor uuu(24);   -- 40: u16=u16+u24
    uu(3)     <= u(3)     xor uuu(7);    -- 41: u3=u3+u7
    uu(0)     <= u(0)     xor uuu(7);    -- 42: u0=u0+u7
    uuu(9)    <= uu(9)    xor uu(16);    -- 43: u9=u9+u16
    uuu(17)   <= uu(17)   xor uu(0);     v(25) <= uuu(17);  -- 44: u17=u17+u0[v25]
    uuuu(25)  <= uuu(25)  xor uuu(1);    v(1)  <= uuuu(25); -- 45: u25=u25+u1[v1]
    uuuu(1)   <= uuu(1)   xor uuu(17);   -- 46: u1=u1+u17
    uu(10)    <= u(10)    xor uuuu(1);   -- 47: u10=u10+u1
    uuu(18)   <= uu(18)   xor uuu(9);    v(2)  <= uuu(18);     -- 48: u18=u18+u9[v2]
    uu(2)     <= u(2)     xor uuu(9);    -- 49: u2=u2+u9
    uuu(10)   <= uu(10)   xor uuu(18);   -- 50: u10=u10+u18
    uuu(2)    <= uu(2)    xor uuu(10);   v(10)  <= uuu(2);    -- 51: u2=u2+u10[v10]
    uuu(3)    <= uu(3)    xor uuu(2);    -- 52: u3=u3+u2
    uuu(11)   <= uu(11)   xor uuu(10);   -- 53: u11=u11+u10
    uuuu(3)   <= uuu(3)   xor uuu(18);   -- 54: u3=u3+u18
    uuu(19)   <= uu(19)   xor uuuu(3);   v(3)   <= uuu(19);   -- 55: u19=u19+u3[v3]
    uuuu(27)  <= uuu(27)  xor uuu(19);   -- 56: u27=u27+u19
    uuu(28)   <= uu(28)   xor uuu(7);    -- 57: u28=u28+u7
    uuuuu(27) <= uuuu(27) xor uuu(23);   v(27)  <= uuuuu(27); -- 58: u27=u27+u23[v27]
    uuu(12)   <= uu(12)   xor uuu(11);   -- 59: u12=u12+u11
    uuuu(12)  <= uuu(12)  xor uuuuu(27); v(20)  <= uuuu(12);  -- 60: u12=u12+u27[v20]
    uuu(20)   <= uu(20)   xor uuu(28);   v(28)  <= uuu(20);   -- 61: u20=u20+u28[v28]

    uuuu(28)  <= uuu(28)  xor uuuu(12);  -- 62: u28=u28+u12
    uuu(4)    <= uu(4)    xor uuu(23);   -- 63: u4=u4+u23
    uuuu(11)  <= uuu(11)  xor uuu(31);   v(19)  <= uuuu(11);  -- 64: u11=u11+u31[v19]
    uu(5)     <= u(5)     xor uuuu(28);  -- 65: u5=u5+u28
    uuuuu(3)  <= uuuu(3)  xor uuuu(11);  -- 66: u3=u3+u11
    uuuu(4)   <= uuu(4)   xor uuuuu(3);  -- 67: u4=u4+u3
    uuu(13)   <= uu(13)   xor uuuu(4);   v(29)  <= uuu(13);  -- 68: u13=u13+u4[v29]
    uuu(29)   <= uu(29)   xor uu(5);     v(5)   <= uuu(29);  -- 69: u29=u29+u5[v5]
    uuu(5)    <= uu(5)    xor uuu(13);   -- 70: u5=u5+u13
    uuu(14)   <= uu(14)   xor uuu(5);    v(30)  <= uuu(5);   -- 71: u14=u14+u5[v30]
    uuu(16)   <= uu(16)   xor uuu(31);   v(8)   <= uuu(16);  -- 72: u16=u16+u31[v8]
    uuuu(26)  <= uuu(26)  xor uuu(2);    v(26)  <= uuuu(26); -- 73: u26=u26+u2[v26]
    uuuu(30)  <= uuu(30)  xor uuu(14);   v(22)  <= uuuu(30); -- 74: u30=u30+u14[v22]
    uuuu(10)  <= uuu(10)  xor uuuu(26);  v(18)  <= uuuu(10); -- 75: u10=u10+u26[v18]
    uuu(0)    <= uu(0)    xor uuu(16);   -- 76: u0=u0+u16
    uuuu(8)   <= uuu(8)   xor uuu(23);   v(16)  <= uuuu(8);   -- 77: u8=u8+u23[v16]
    uuuu(22)  <= uuu(22)  xor uuuu(30);  v(6)   <= uuuu(22);  -- 78: u22=u22+u30[v6]
    uuuu(0)   <= uuu(0)   xor uuuu(8);   v(24)  <= uuuu(0);   -- 79: u0=u0+u8[v24]
    uuuu(6)   <= uuu(6)   xor uuuu(22);  v(14)  <= uuuu(6);   -- 80: u6=u6+u22[v14]
    uuuu(9)   <= uuu(9)   xor uuuu(25);  v(9)   <= uuuu(9);   -- 81: u9=u9+u25[v9]
    uuuu(7)   <= uuu(7)   xor uuu(15);   v(15)  <= uuuu(7);   -- 82: u7=u7+u15[v15]
    uuuu(24)  <= uuu(24)  xor uuuu(0);   v(0)   <= uuuu(24);  -- 83: u24=u24+u0[v0]
    uuuu(21)  <= uuu(21)  xor uuu(29);   v(21)  <= uuuu(21);  -- 84: u21=u21+u29[v21]
    uuuuu(4)  <= uuuu(4)  xor uuu(20);   v(4)   <= uuuuu(4);  -- 85: u4=u4+u20[v4]
    uuuuuu(3) <= uuuuu(3) xor uuuuu(27); v(11)  <= uuuuuu(3); -- 86: u3=u3+u27[v11]
    uuuuu(1)  <= uuuu(1)  xor uuuu(9);   v(17)  <= uuuuu(1);  -- 87: u1=u1+u9[v17]
    uuuu(5)   <= uuu(5)   xor uuuu(21);  v(13)  <= uuuu(5);   -- 88: u5=u5+u21[v13]
    uuuuu(28) <= uuuu(28) xor uuuuu(4);  v(12)  <= uuuuu(28); -- 89: u28=u28+u4[v12]
    uuuu(23)  <= uuu(23)  xor uuuu(7);   v(31)  <= uuuu(23);  -- 90: u23=u23+u7[v31]
    uuuu(31)  <= uuu(31)  xor uuuu(23);  v(23)  <= uuuu(31);  -- 91: u31=u31+u23[v23]

    mo(7 downto 0)   <= v(31 downto 24);
    mo(15 downto 8)  <= v(23 downto 16);
    mo(23 downto 16) <= v(15 downto 8);
    mo(31 downto 24) <= v(7  downto 0);

    --proc : process(all)
    --  variable x, y : std_logic_vector(31 downto 0);
    --begin
    --    
    --   x(7 downto 0)   := mi(31 downto 24);
    --   x(15 downto 8)  := mi(23 downto 16);
    --   x(23 downto 16) := mi(15 downto 8);
    --   x(31 downto 24) := mi(7  downto 0);

    --   x(23) := x(23) xor x(31);    
    --   x(31) := x(31) xor x(15);    
    --   x(12) := x(12) xor x( 4);    
    --   x(13) := x(13) xor x(21);    
    --   x(17) := x(17) xor x( 9);    
    --   x(11) := x(11) xor x(27);    
    --   x( 4) := x( 4) xor x(28);    
    --   x(21) := x(21) xor x( 5);    
    --   x( 0) := x( 0) xor x(24);    
    --   x(15) := x(15) xor x( 7);    
    --   x( 9) := x( 9) xor x( 1);    
    --   x(14) := x(14) xor x( 6);    
    --   x(24) := x(24) xor x(16);    
    --   x( 6) := x( 6) xor x(22);    
    --   x(16) := x(16) xor x(31);    
    --   x(24) := x(24) xor x( 8);    
    --   x(18) := x(18) xor x(26);    
    --   x(22) := x(22) xor x(30);    
    --   x(26) := x(26) xor x(10);    
    --   x( 8) := x( 8) xor x(23);    
    --   x(30) := x(30) xor x(13);    
    --   x(13) := x(13) xor x(29);    
    --   x( 5) := x( 5) xor x(13);    
    --   x(29) := x(29) xor x( 4);    
    --   x( 4) := x( 4) xor x(11);    
    --   x(11) := x(11) xor x(19);    
    --   x(13) := x(13) xor x(12);    y(5) := x(13);
    --   x(19) := x(19) xor x(23);    
    --   x( 4) := x( 4) xor x(31);    
    --   x(12) := x(12) xor x(20);    
    --   x(28) := x(28) xor x(12);    
    --   x(20) := x(20) xor x(27);    
    --   x(20) := x(20) xor x(19);    
    --   x(27) := x(27) xor x(31);    
    --   x(12) := x(12) xor x(15);    
    --   x(27) := x(27) xor x( 3);    
    --   x( 3) := x( 3) xor x(11);    
    --   x(11) := x(11) xor x( 2);    
    --   x(19) := x(19) xor x(18);    
    --   x(11) := x(11) xor x(10);    
    --   x(10) := x(10) xor x(18);    
    --   x(18) := x(18) xor x( 2);    
    --   x(10) := x(10) xor x( 9);    y(2) := x(10);
    --   x( 2) := x( 2) xor x( 9);    
    --   x(18) := x(18) xor x(17);    y(10) := x(18);
    --   x(17) := x(17) xor x(25);    
    --   x( 1) := x( 1) xor x(17);    
    --   x(25) := x(25) xor x(24);    
    --   x( 9) := x( 9) xor x( 8);    
    --   x(24) := x(24) xor x(15);    y(0) := x(24);
    --   x(11) := x(11) xor x(15);    y(3) := x(11);
    --   x( 8) := x( 8) xor x( 0);    y(16) := x(8);
    --   x(15) := x(15) xor x(23);    
    --   x(17) := x(17) xor x(16);    
    --   x(16) := x(16) xor x( 0);    
    --   x( 0) := x( 0) xor x(31);    
    --   x(16) := x(16) xor x(23);    y(8) := x(16);
    --   x(23) := x(23) xor x( 6);    
    --   x(31) := x(31) xor x( 7);    
    --   x(31) := x(31) xor x(22);    y(23) := x(31);
    --   x(30) := x(30) xor x( 6);    y(14) := x(30);
    --   x( 7) := x( 7) xor x(14);    
    --   x(14) := x(14) xor x(21);    
    --   x( 6) := x( 6) xor x( 5);    
    --   x(22) := x(22) xor x(21);    
    --   x( 5) := x( 5) xor x(29);    y(29) := x(5);
    --   x(21) := x(21) xor x(28);    
    --   x(29) := x(29) xor x(21);    y(13) := x(29);
    --   x(21) := x(21) xor x(13);    y(21) := x(21);
    --   x(12) := x(12) xor x(27);    y(28) := x(12);
    --   x(27) := x(27) xor x(26);    
    --   x(28) := x(28) xor x(20);    y(20) := x(28);
    --   x(20) := x(20) xor x( 4);    y(12) := x(20);
    --   x(26) := x(26) xor x( 1);    
    --   x(14) := x(14) xor x(30);    y( 6) := x(14);
    --   x( 4) := x( 4) xor x(12);    y( 4) := x(4);
    --   x( 3) := x( 3) xor x(19);    y(19) := x(3);
    --   x(19) := x(19) xor x(27);    y(11) := x(19);
    --   x( 1) := x( 1) xor x(25);    
    --   x( 0) := x( 0) xor x(24);    y(24) := x(0);
    --   x( 1) := x( 1) xor x( 0);    y(25) := x(1);
    --   x( 2) := x( 2) xor x(26);    y(18) := x(2);
    --   x(25) := x(25) xor x( 9);    y(17) := x(25);
    --   x(15) := x(15) xor x( 7);    y( 7) := x(15);
    --   x( 7) := x( 7) xor x(23);    y(15) := x(7);
    --   x( 6) := x( 6) xor x(14);    y(22) := x(6);
    --   x( 9) := x( 9) xor x(17);    y( 9) := x(9);
    --   x(23) := x(23) xor x(31);    y(31) := x(23);
    --   x(26) := x(26) xor x(18);    y(26) := x(26);
    --   x(22) := x(22) xor x( 6);    y(30) := x(22);
    --   x(17) := x(17) xor x( 0);    y( 1) := x(17);
    --   x(27) := x(27) xor x(11);    y(27) := x(27);

    --   mo(7 downto 0)   <= y(31 downto 24);
    --   mo(15 downto 8)  <= y(23 downto 16);
    --   mo(23 downto 16) <= y(15 downto 8);
    --   mo(31 downto 24) <= y(7  downto 0);

    --end process;

end architecture;

