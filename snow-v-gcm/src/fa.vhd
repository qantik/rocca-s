library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.all;
use work.snow_gcm_pkg.all;

entity fa is
  generic (adder_conf : adder_t_enum);
  port(
        A : in std_logic_vector(255 downto 0);
        B : in std_logic_vector(255 downto 0);
        R1 : in std_logic_vector(127 downto 0);
        R2 : in std_logic_vector(127 downto 0);
        init : in std_logic;
        An : out std_logic_vector(255 downto 0);
        z : out std_logic_vector(127 downto 0)
      );
end;


architecture parallel of fa is
    signal a1, a2: std_logic_vector(255 downto 0);
    signal tmp1, tmp2, tmp3 : std_logic_vector(127 downto 0);
    signal T1_inv, T1 : std_logic_vector(127 downto 0);
begin

    b_invert: entity byte_invert port map (B(127 downto 0), T1_inv);
    w_invert: entity word_invert generic map (SIZE => 8) port map (T1_inv, T1);
    
    wadder0 : entity word_adder generic map(adder_conf) port map (R1, T1, tmp1);
    tmp2 <= tmp1 xor R2;
    lfsr_a0 : entity lfsr_a port map(A, B, a1);
    
    process (init, a1, tmp2)
    begin
        if init = '1' then
            An(127 downto 0) <= a1(127 downto 0);
            An(255 downto 128) <= a1(255 downto 128) xor tmp2;
        else
            An <= a1;
        end if;
    end process;
    
    z <= tmp2;
		
end architecture;

