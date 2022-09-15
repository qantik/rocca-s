library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity snow is
  generic (R : integer := 2);
  port(
        CLK : in std_logic;
        RST : in std_logic;
        K : in std_logic_vector(255 downto 0);
        IV : in std_logic_vector(127 downto 0);
        Z : out std_logic_vector(128*R+128-1 downto 0)
      );
end;


architecture ballif of snow is

    type doublereg is array (R downto 0) of std_logic_vector(255 downto 0);
    type fullreg is array (R downto 0) of std_logic_vector(127 downto 0);
    type keystream is array (R downto 1) of std_logic_vector(127 downto 0);

    signal A,B : doublereg;
    signal R1, R2, R3 : fullreg;
    signal ZZ : keystream;

    signal An, Bn: std_logic_vector(255 downto 0);
    signal key_flipped, key_inverted, R1n, R2n, R3n : std_logic_vector(127 downto 0);

    signal load : std_logic;
    signal addKeyLeft, addKeyRight, init : std_logic_vector(R downto 1);

begin

    word_invert0: entity word_invert generic map (SIZE => 8) port map (K(255 downto 128), key_flipped);
    key_inversion0: entity byte_invert port map (key_flipped, key_inverted);
    An <= K(127 downto 0) & IV(127 downto 0) when load = '1' else A(R);
    Bn <= (127 downto 0 => '0') & key_inverted when load = '1' else B(R);
    
    R1n <= (others => '0') when load = '1' else R1(R);
    R2n <= (others => '0') when load = '1' else R2(R);
    R3n <= (others => '0') when load = '1' else R3(R);
    
    
    reg_A : entity reg generic map(SIZE => 256) port map (CLK, An, A(0));
    reg_B : entity reg generic map(SIZE => 256) port map (CLK, Bn, B(0));
    reg_R1: entity reg generic map(SIZE => 128) port map (CLK, R1n, R1(0));
    reg_R2: entity reg generic map(SIZE => 128) port map (CLK, R2n, R2(0));
    reg_R3: entity reg generic map(SIZE => 128) port map (CLK, R3n, R3(0));
    
    comb_block: for i in 0 to R  generate
        fa0 : entity fa port map(A(i), B(i), R1(i), R2(i), init(i+1), A(i+1), ZZ(i+1));
        fb0 : entity fb port map(A(i), B(i), B(i+1));
        fr1_0 : entity fr1 port map (A(i), K, R2(i), R3(i), addKeyLeft(i+1), addKeyRight(i+1), R1(i+1));
        fr2_0 : entity fr2 port map (R1(i), R2(i+1));
        fr3_0 : entity fr3 port map (R2(i), R3(i+1));
    end generate;
    
    controller0 : entity controller generic map(R) port map (CLK, RST, addKeyLeft, addKeyRight, init, load);
    
    wiringZ : for i in 0 to R  generate
        Z(128*i+127 downto 128*i) <= ZZ(i+1);
    end generate;


end architecture ballif;

