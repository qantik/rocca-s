library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

--use work.aes_pack.all;
entity testbench is
end testbench;


architecture tb of testbench is   

    function to_string ( a: std_logic_vector) return string is
        variable b : string (1 to a'length) := (others => NUL);
        variable stri : integer := 1; 
        begin
            for i in a'range loop
                b(stri) := std_logic'image(a((i)))(2);
            stri := stri+1;
            end loop;
        return b;
    end function;

    function ceil_div (a: integer; b: integer) return integer is
        variable i, bitCount : natural;
    begin
        if a rem b > 0 then
            return 1 + a/b;
        else
            return a/b;
        end if;
    end ceil_div;

    constant clkphase: time:= 50 ns;    
    constant resetactivetime:    time:= 25 ns;
    
    file testinput, testoutput, correct_v : TEXT;   
     
    constant STREAM_SIZE_IN_BLOCKS : integer := 10;
    constant R : integer := 2;
    
    type keystream is array (R downto 1) of std_logic_vector(127 downto 0);
    
    signal CLK              : std_logic;
    signal RST              : std_logic;
    signal K                : std_logic_vector(255 downto 0);
    signal IV               : std_logic_vector(127 downto 0);
    signal Z                : std_logic_vector(128*R-1 downto 0);--keystream;
    
begin

    mut : entity work.snow
        port map (
            CLK => CLK,
            RST => RST,
            K => K,
            IV => IV,
            Z => Z
        );

    process
    begin
        CLK <= '1'; wait for clkphase;
        CLK <= '0'; wait for clkphase;
    end process;
  -- obtain stimulus and apply it to MUT
  ----------------------------------------------------------------------------
    a : process
        variable INLine         : line;
        variable tmp128         : std_logic_vector(127 downto 0);
        variable tmp256         : std_logic_vector(255 downto 0);
        variable ctr            : integer range 0 to 1000;
    begin
        file_open(testinput, "../test/IN", read_mode);
        file_open(testoutput, "../test/res", write_mode);
        file_open(correct_v, "../test/OUT", read_mode);
        appli_loop : while not (endfile(testinput)) loop
        
            RST      <= '0';
            wait for resetactivetime;
            RST <= '1';
            
            wait until falling_edge(CLK);
                
            readline(testinput, INLine);    hread(INLine, tmp256);       K <= tmp256;
            readline(testinput, INLine);    hread(INLine, tmp128);       IV <= tmp128;

            wait for 32*clkphase; -- lets the initialization run (steal 1 more cycle from the following loop)

            core_loop: for i in 0 to ceil_div(STREAM_SIZE_IN_BLOCKS,R)-1 loop
                wait for 2*clkphase; 
                --hwrite(INLine,  z); writeline(testoutput, INLine);
                --readline(correct_v, INLine); hread(INLine, tmp128);
                --assert tmp128  = z report "STREAM DOES NOT MATCH" severity failure;
            end loop;

            wait until rising_edge(CLK);
            
        end loop appli_loop;
        
        assert false report "DONE" severity failure;
        wait until clk'event and clk = '1';
        wait;
    end process a;
end tb;
