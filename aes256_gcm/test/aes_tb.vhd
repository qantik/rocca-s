library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

library work;
use work.all;
use work.aes256_gcm_pkg.all;

entity aes_tb is

    function vector_equal(a, b : std_logic_vector) return boolean is
    begin
        for i in 0 to a'length-1 loop
            if a(i) /= b(i) then
                return false;
            end if;
        end loop;
        return true;
    end function;

end entity;

architecture test of aes_tb is

    -- Input signals.
    signal clk     : std_logic;
    signal reset_n : std_logic;
    
    signal key : std_logic_vector(255 downto 0);
    signal pt  : std_logic_vector(127 downto 0);

    -- Output signals.
    signal ct  : std_logic_vector(127 downto 0);

    constant clk_period   : time := 100 ns;
    constant reset_period : time := 25 ns;

begin

    uut : entity work.aes
        port map (clk       => clk,
                  reset_n   => reset_n,
                  
                  key       => key,
                  pt        => pt,
                  ct        => ct);

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    test : process
        variable vec_line  : line;
        variable vec_space : character;

        variable vec_id  : integer;
        variable vec_key : std_logic_vector(255 downto 0);
        variable vec_pt  : std_logic_vector(127 downto 0);
        variable vec_ct  : std_logic_vector(127 downto 0);
        
        file test_vectors : text;
        
        procedure run(constant v_key : in std_logic_vector(255 downto 0);
                      constant v_pt  : in std_logic_vector(127 downto 0); 
                      constant v_ct  : in std_logic_vector(127 downto 0)) is
	    begin
	        key <= v_key;
            pt  <= v_pt;

	        reset_n <= '0';
            wait for reset_period;
            reset_n <= '1';
            wait for clk_period - reset_period;

            wait for (14)*clk_period; -- initialization

            assert vector_equal(ct, v_ct) report "wrong tag" severity failure;
	    	
        end procedure run;
        
    begin
        file_open(test_vectors, "../test/aes_vectors.txt", read_mode);

        while not endfile(test_vectors) loop
        --for z in 1 to 20 loop
                
	        readline(test_vectors, vec_line);
            read(vec_line, vec_id);
                
            readline(test_vectors, vec_line);
            hread(vec_line, vec_key);
            readline(test_vectors, vec_line);
            hread(vec_line, vec_pt);
            readline(test_vectors, vec_line);
            hread(vec_line, vec_ct);

            report "vector: " & integer'image(vec_id);

            run(vec_key, vec_pt, vec_ct);

        end loop;

        assert false report "test passed" severity failure;

    end process;

end architecture;

