library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.snow_gcm_pkg.all;

entity snow is
  port(
        CLK : in std_logic;
        cycle : in unsigned(4 downto 0);
        K : in std_logic_vector(255 downto 0);
        IV : in std_logic_vector(127 downto 0);
        Z : out std_logic_vector(128*R-1 downto 0);
        run : in std_logic
      );
end;

architecture structural of snow is

    type doublereg is array (R downto 0) of std_logic_vector(255 downto 0);
    type fullreg is array (R downto 0) of std_logic_vector(127 downto 0);
    type keystream is array (R  downto 1) of std_logic_vector(127 downto 0);

    signal A,B : doublereg;
    signal R1, R2, R3 : fullreg;
    signal ZZ : keystream;
    signal Zi : std_logic_vector(128*R-1 downto 0);

    signal An, Bn, Ki : std_logic_vector(255 downto 0);
    signal key_flipped, key_inverted, R1n, R2n, R3n, IVi : std_logic_vector(127 downto 0);

    signal load : std_logic;
    signal addKeyLeft, addKeyRight, init : std_logic_vector(R downto 1);

    constant initb : std_logic_vector(127 downto 0) := X"6C4178656B452064694A676E68546D6F";

begin

    wordi : entity word_invert generic map (SIZE => 8) port map (K(255 downto 128), key_flipped);
    keyi  : entity byte_invert port map (key_flipped, key_inverted);
    An <= K(127 downto 0) & IV(127 downto 0) when load = '1' else A(R);
    --Bn <= (127 downto 0 => '0') & key_inverted when load = '1' else B(R);
    Bn <= initb & key_inverted when load = '1' else B(R);
    --Bn <= key_inverted & initbb when load = '1' else B(R);
    
    R1n <= (others => '0') when load = '1' else R1(R);
    R2n <= (others => '0') when load = '1' else R2(R);
    R3n <= (others => '0') when load = '1' else R3(R);
    
    reg_A : entity reg generic map(SIZE => 256) port map (CLK, run, An, A(0));
    reg_B : entity reg generic map(SIZE => 256) port map (CLK, run, Bn, B(0));
    reg_R1: entity reg generic map(SIZE => 128) port map (CLK, run, R1n, R1(0));
    reg_R2: entity reg generic map(SIZE => 128) port map (CLK, run, R2n, R2(0));
    reg_R3: entity reg generic map(SIZE => 128) port map (CLK, run, R3n, R3(0));
    
    comb_block: for i in 0 to R-1  generate
      fa0 : entity fa port map(A(i), B(i), R1(i), R2(i), init(i+1), A(i+1), ZZ(i+1));
      fb0 : entity fb port map(A(i), B(i), B(i+1));
      fr1_0 : entity fr1 port map (A(i), K, R2(i), R3(i), addKeyLeft(i+1), addKeyRight(i+1), R1(i+1));
      fr2_0 : entity fr2 port map (R1(i), R2(i+1));
      fr3_0 : entity fr3 port map (R2(i), R3(i+1));
    end generate;
    
    dis : entity dispatch port map (CLK, cycle, addKeyLeft, addKeyRight, init, load);
    
    wiringZ : for i in 0 to R-1 generate
        Zi(128*i+127 downto 128*i) <= ZZ(R-i);
    end generate;

    lele : for i in 0 to (r*16)-1 generate
        Z(8*(i+1)-1 downto 8*i) <= Zi(r*128-(8*i)-1 downto r*128-(8*(i+1)));
    end generate;
    --lulu : for i in 0 to 15 generate
    --    IVi(8*(i+1)-1 downto 8*i) <= IV(128-(8*i)-1 downto 120-(8*i));
    --end generate;
    --lala : for i in 0 to 31 generate
    --    Ki(8*(i+1)-1 downto 8*i) <= K(256-(8*i)-1 downto 248-(8*i));
    --end generate;

end architecture;

