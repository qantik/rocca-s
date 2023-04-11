library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

library work;
use work.all;
use work.rocca_unrolled_f_pkg.all;

entity rocca_unrolled_f_tb is

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

architecture test of rocca_unrolled_f_tb is
    
    -- Input signals.
    signal clk   : std_logic := '0';
    signal reset : std_logic;
    
    signal nonce : std_logic_vector(127 downto 0);
    signal key   : std_logic_vector(255 downto 0);

    signal last_block : std_logic;

    signal data      : std_logic_vector((256*r)-1 downto 0);
    signal ad_empty  : std_logic;
    signal ad_len    : std_logic_vector(127 downto 0);
    signal msg_empty : std_logic;
    signal msg_len   : std_logic_vector(127 downto 0);

    -- Output signals.
    signal ct  : std_logic_vector((256*r)-1 downto 0);
    signal tag : std_logic_vector(255 downto 0);

    constant clk_period   : time := 100 ns;
    constant reset_period : time := 25 ns;

begin

    uut : entity work.rocca_unrolled_f
        port map (clk        => clk,
                  reset      => reset,
                  
                  nonce      => nonce,
                  key        => key,
                  
                  last_block => last_block,
                  
                  data      => data,
                  ad_empty  => ad_empty,
                  ad_len    => ad_len,
                  msg_empty => msg_empty,
                  msg_len   => msg_len,

                  ct        => ct,
                  tag       => tag);

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    test : process
        constant data_max : integer := 100;
        type data_array is array (data_max-1 downto 0) of std_logic_vector(255 downto 0);

        variable vec_line  : line;
        variable vec_space : character;

        variable vec_id        : integer;
        variable vec_ad_len    : integer;
        variable vec_msg_len   : integer;
        variable vec_nonce     : std_logic_vector(127 downto 0);
        variable vec_key       : std_logic_vector(255 downto 0);
        variable vec_ad_array  : data_array;
        variable vec_msg_array : data_array;
        variable vec_ct_array  : data_array;
        variable vec_tag       : std_logic_vector(255 downto 0);
        variable tmp           : std_logic_vector(255 downto 0);
        
        file test_vectors : text;
        
        procedure run(constant v_nonce     : in std_logic_vector(127 downto 0);
                      constant v_key       : in std_logic_vector(255 downto 0);
                      constant v_ad_array  : in data_array; 
                      constant v_msg_array : in data_array; 
                      constant v_ct_array  : in data_array; 
                      constant v_ad_len    : in integer;
                      constant v_msg_len   : in integer;
                      constant v_tag       : in std_logic_vector(255 downto 0)) is
	    begin
	    nonce <= v_nonce;
	    key   <= v_key;
            data  <= (others => '0');

            ad_len  <= std_logic_vector(to_unsigned(v_ad_len*256, ad_len'length));
            msg_len <= std_logic_vector(to_unsigned(v_msg_len*256, msg_len'length));
            if v_ad_len  > 0 then ad_empty  <= '0'; else ad_empty  <= '1'; end if;
            if v_msg_len > 0 then msg_empty <= '0'; else msg_empty <= '1'; end if;
            last_block <= '0';

            reset <= '1';
            wait for clk_period;
            reset <= '0';

            wait for (16/r)*clk_period; -- initialization

            ad_loop0 : for i in 0 to ((v_ad_len)/r)-1 loop
                wait for clk_period;
                ad_loop1: for j in 0 to r-1 loop
                    data((256*(j+1))-1 downto 256*j) <= v_ad_array(i*r+j);
                end loop;
                if i = ((v_ad_len)/r)-1 then last_block <= '1'; end if;
            end loop;

            
	        msg_loop0 : for i in 0 to ((v_msg_len)/r)-1 loop
                wait for clk_period/2;
                msg_loop1: for j in 0 to r-1 loop
                    data((256*(j+1))-1 downto 256*j) <= v_msg_array(i*r+j);
                end loop;
                if i = ((v_msg_len)/r)-1 then last_block <= '1'; else last_block <= '0'; end if;
                wait for clk_period/2;
                check_loop: for j in 0 to r-1 loop
                    --assert vector_equal(ct((256*(j+1))-1 downto 256*j), v_ct_array(i*r+j)) report "wrong ct" severity failure;
                end loop;
            end loop;
            
            wait for (16/r)*clk_period;
            wait for clk_period;
                
            assert vector_equal(tag, v_tag) report "wrong tag" severity failure;
	    	
        end procedure run;
        
    begin
        file_open(test_vectors, "../test/vectors.txt", read_mode);

        while not endfile(test_vectors) loop
                
	        readline(test_vectors, vec_line);
            read(vec_line, vec_id); read(vec_line, vec_space);
            read(vec_line, vec_ad_len); read(vec_line, vec_space);
            read(vec_line, vec_msg_len); 
                
            readline(test_vectors, vec_line);
            hread(vec_line, vec_nonce);
            readline(test_vectors, vec_line);
            hread(vec_line, vec_key);

            for i in 0 to vec_ad_len-1 loop
                readline(test_vectors, vec_line);
                hread(vec_line, vec_ad_array(i));
            end loop;
            for i in 0 to vec_msg_len-1 loop
                readline(test_vectors, vec_line);
                hread(vec_line, vec_msg_array(i));
            end loop;
            for i in 0 to vec_msg_len-1 loop
                readline(test_vectors, vec_line);
                hread(vec_line, vec_ct_array(i));
            end loop;
                
            readline(test_vectors, vec_line);
            hread(vec_line, vec_tag);
	        
            report "vector: " & integer'image(vec_id);

            run(vec_nonce, vec_key, vec_ad_array, vec_msg_array, vec_ct_array,
                vec_ad_len, vec_msg_len, vec_tag);

        end loop;

        assert false report "test passed" severity failure;

    end process;

end architecture;

