library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity mul_b is
  port(
        B0 : in std_logic_vector(15 downto 0);
        B3 : in std_logic_vector(15 downto 0);
        B8 : in std_logic_vector(15 downto 0);
        A0 : in std_logic_vector(15 downto 0);
        B15 : out std_logic_vector(15 downto 0)
      );
end;

-- Fatih says:
-- 1 out of 8 cycle of LFSR

architecture ballif of mul_b is

    signal tmp1, tmp2 : std_logic_vector(15 downto 0);
    signal term1, term2 : std_logic_vector(15 downto 0);

begin
    -- from refernce C code:
        -- u16 u = mul_x(A[0], 0x990f) ^ A[1] ^ mul_x_inv(A[8], 0xcc87) ^ B[0];
        -- u16 v = mul_x(B[0], 0xc963) ^ B[3] ^ mul_x_inv(B[8], 0xe4b1) ^ A[0];
    tmp1 <= B0(14 downto 0) & '0';
    tmp2 <= '0' & B8(15 downto 1);
    term1 <= tmp1 when B0(15) = '0' else (tmp1 xor x"c963");
    term2 <= tmp2 when B8(0) = '0' else (tmp2 xor x"e4b1");
    
    B15 <= term1 xor term2 xor B3 xor A0;
		
end architecture ballif;

