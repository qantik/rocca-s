library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity rocca_byte_f_tb is

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

architecture test of rocca_byte_f_tb is

    -- Input signals.
    signal clk     : std_logic;
    signal reset_n : std_logic;
    signal start   : std_logic;
    
    signal nonce : std_logic_vector(7 downto 0);
    signal key   : std_logic_vector(15 downto 0);
    signal z     : std_logic_vector(15 downto 0);

    signal last_block : std_logic;

    signal data      : std_logic_vector(15 downto 0);
    signal ad_empty  : std_logic;
    signal ad_len    : std_logic_vector(7 downto 0);
    signal msg_empty : std_logic;
    signal msg_len   : std_logic_vector(7 downto 0);

    -- Output signals.
    signal ct  : std_logic_vector(15 downto 0);
    signal tag : std_logic_vector(15 downto 0);

    constant clk_period   : time := 100 ns;
    constant reset_period : time := 25 ns;
    
    constant z0   : std_logic_vector(127 downto 0)  := X"428A2F98D728AE227137449123EF65CD";
    constant z1   : std_logic_vector(127 downto 0)  := X"B5C0FBCFEC4D3B2FE9B5DBA58189DBBC";

begin

    uut : entity work.rocca_byte_f
        port map (clk        => clk,
                  reset_n    => reset_n,
                  start      => start,
                  
                  nonce      => nonce,
                  key        => key,
                  z          => z,
                  
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

        variable vv_ad_len  : std_logic_vector(127 downto 0);
        variable vv_msg_len : std_logic_vector(127 downto 0);
        variable cmp        : std_logic_vector(255 downto 0);

        variable t : integer;

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
            vv_ad_len  := std_logic_vector(to_unsigned(v_ad_len, 128));
            vv_msg_len := std_logic_vector(to_unsigned(v_msg_len, 128));
            
            if v_ad_len  > 0 then ad_empty  <= '0'; else ad_empty  <= '1'; end if;
            if v_msg_len > 0 then msg_empty <= '0'; else msg_empty <= '1'; end if;

            data       <= (others => '0');
            key        <= (others => '0');
            nonce      <= (others => '0');
            z          <= (others => '0');
            ad_len     <= (others => '0');
            msg_len    <= (others => '0');
            last_block <= '0';
            start      <= '0';

	        reset_n <= '0';
            wait for reset_period;
	        reset_n <= '1';
            wait for 3*reset_period;

            start <= '1';
            wait for clk_period;
            start <= '0';
            
            load_loop : for i in 0 to 15 loop
                t := 8*(i mod 16);

                nonce <= v_nonce(127-t downto 120-t);
                key   <= v_key(255-t downto 248-t) & v_key(127-t downto 120-t);
                z     <= z0(127-t downto 120-t) & z1(127-t downto 120-t);
                wait for clk_period;
            end loop;

            init_loop0 : for i in 0 to 15 loop
                init_loop1 : for j in 0 to 63 loop
                    t := 8*(j mod 16);
                    
                    nonce <= v_nonce(127-t downto 120-t);
                    key   <= v_key(255-t downto 248-t) & v_key(127-t downto 120-t);
                    z     <= z0(127-t downto 120-t) & z1(127-t downto 120-t);
                    wait for clk_period;
                end loop;
            end loop;
            
            ad_loop0 : for i in 0 to v_ad_len-1 loop

                if i = v_ad_len-1 then last_block <= '1'; else last_block <= '0'; end if;

                ad_loop1 : for j in 0 to 63 loop
                    t := 8*(j mod 16);
                    
                    nonce <= v_nonce(127-t downto 120-t);
                    key   <= v_key(255-t downto 248-t) & v_key(127-t downto 120-t);
                    data  <= v_ad_array(i)(255-t downto 248-t) & v_ad_array(i)(127-t downto 120-t);
                    wait for clk_period;
                end loop;
            end loop;
            
            msg_loop0 : for i in 0 to v_msg_len-1 loop

                if i = v_msg_len-1 then last_block <= '1'; else last_block <= '0'; end if;

                msg_loop1 : for j in 0 to 95 loop
                    t := 8*(j mod 16);
                    
                    nonce <= v_nonce(127-t downto 120-t);
                    key   <= v_key(255-t downto 248-t) & v_key(127-t downto 120-t);
                    data  <= v_msg_array(i)(255-t downto 248-t) & v_msg_array(i)(127-t downto 120-t);
                    wait for clk_period;
                end loop;
            end loop;

            last_block <= '0';
            
            tag_loop0 : for i in 0 to 15 loop
                tag_loop1 : for j in 0 to 63 loop
                    t := 8*(j mod 16);
                    
                    nonce <= v_nonce(127-t downto 120-t);
                    key   <= v_key(255-t downto 248-t) & v_key(127-t downto 120-t);
                    ad_len  <= vv_ad_len(127-t downto 120-t);
                    msg_len <= vv_msg_len(127-t downto 120-t);
                    wait for clk_period;
                end loop;
            end loop;
            
            tag_loop : for i in 0 to 15 loop
                cmp(255-(8*i) downto 248-(8*i)) := tag(15 downto 8);
                cmp(127-(8*i) downto 120-(8*i)) := tag(7 downto 0);
                wait for clk_period;
            end loop;
            assert vector_equal(cmp,  v_tag) report "wrong tag" severity failure;

        end procedure run;
        
    begin
        file_open(test_vectors, "../test/vectors_byte_f2.txt", read_mode);

        while not endfile(test_vectors) loop
        --for z in 1 to 1 loop
                
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

