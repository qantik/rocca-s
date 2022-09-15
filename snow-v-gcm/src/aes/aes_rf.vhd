library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity aes_rf is
  port(
        PT    : in  std_logic_vector(127 downto 0);
        CT    : out std_logic_vector(127 downto 0)
      );
end aes_rf;

-- Fatih says:
-- I copied this impl. from Energy-Efficieny AES work (ongoing, not published)
-- This impl. uses:
--      DaE Sbox : decode-and-encode implementation
--      SR : just rewiring component with no cost
--      dui MC : 103-gate from Banik with low-depth (there is a paper about low-depth impl.)

architecture ballif of aes_rf is
    
    signal t1, t2: std_logic_vector(127 downto 0);
	signal tmp1, tmp2: std_logic_vector(127 downto 0);

begin

-- the stupid SnowV paper uses the wrong (w.r.t FIPS document) way of bit mapping
-- so we have to invert the byte sequence

    inversion0 : entity byte_invert port map (PT, t1);

	sbox128_0: entity sbox128 port map(t1, tmp1);
	shiftrow0: entity shiftrows port map(tmp1, tmp2);
	mixcolumns0: entity mixcolumns port map(tmp2, t2);
		
    inversion1 : entity byte_invert port map (t2, CT);
    	
end architecture ballif;

