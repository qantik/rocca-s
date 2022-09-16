library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity mul_a is
  port(
        A0 : in std_logic_vector(15 downto 0);
        A1 : in std_logic_vector(15 downto 0);
        A8 : in std_logic_vector(15 downto 0);
        B0 : in std_logic_vector(15 downto 0);
        A15 : out std_logic_vector(15 downto 0)
      );
end;

-- 1 out of 8 cycle of LFSR

architecture parallel of mul_a is

    signal tmp1, tmp2 : std_logic_vector(15 downto 0);
    signal term1, term2 : std_logic_vector(15 downto 0);

begin
    -- from refernce C code:
        -- u16 u = mul_x(A[0], 0x990f) ^ A[1] ^ mul_x_inv(A[8], 0xcc87) ^ B[0];
    tmp1 <= A0(14 downto 0) & '0';
    tmp2 <= '0' & A8(15 downto 1) ;
    term1 <= tmp1 when A0(15) = '0' else (tmp1 xor x"990f");
    term2 <= tmp2 when A8(0) = '0' else (tmp2 xor x"cc87");
    
    A15 <= term1 xor term2 xor A1 xor B0;
		
end architecture;

