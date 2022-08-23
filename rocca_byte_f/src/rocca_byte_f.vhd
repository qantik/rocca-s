library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;

entity rocca_byte_f is
    port (clk   : in std_logic;
          reset : in std_logic;

          nonce : in std_logic_vector(7 downto 0);
          key   : in std_logic_vector(15 downto 0);
          z     : in std_logic_vector(15 downto 0);
       
          last_block : in std_logic;
          
          data      : in std_logic_vector(15 downto 0);
          ad_len    : in std_logic_vector(7 downto 0);
          ad_empty  : in std_logic;
          msg_len   : in std_logic_vector(7 downto 0);
          msg_empty : in std_logic;
          
          ct        : out std_logic_vector(15 downto 0);
          tag       : out std_logic_vector(15 downto 0));
end entity;

architecture structural of rocca_byte_f is

    signal k0, k1 : std_logic_vector(7 downto 0);
    signal d0, d1 : std_logic_vector(7 downto 0);
    signal z0, z1 : std_logic_vector(7 downto 0);

    type byte_array is array (integer range <>) of std_logic_vector(7 downto 0);
    signal aes_in      : byte_array (0 to 6);
    signal aes_out     : byte_array (0 to 6);
    signal aes_enc_en0 : std_logic_vector(0 to 6);
    signal aes_enc_en1 : std_logic_vector(0 to 6);
    signal aes_dec_en0 : std_logic;
    signal aes_dec_en1 : std_logic;
    
    signal cycle : unsigned(3 downto 0);
    signal round : unsigned(3 downto 0);
    signal phase : unsigned(4 downto 0);

begin

    k0 <= key(15 downto 8);  k1 <= key(7 downto 0);
    d0 <= data(15 downto 8); d1 <= data(7 downto 0);
    z0 <= z(15 downto 8);    z1 <= z(7 downto 0);

    aes_in_mux : process(all)
    begin

        if phase = 0 then
            aes_in(0) <= k1;
            aes_in(1) <= nonce;
            aes_in(2) <= z0;
            aes_in(3) <= k0;
            aes_in(4) <= z1;
            aes_in(5) <= nonce xor k1;
            aes_in(6) <= (others => '0');
        elsif phase = 1 or phase = 5 or phase = 11 or phase = 15 then
            aes_in(0) <= aes_out(0);
            aes_in(1) <= aes_out(1);
            aes_in(2) <= aes_out(2);
            aes_in(3) <= aes_out(3);
            aes_in(4) <= aes_out(4);
            aes_in(5) <= aes_out(5);
            aes_in(6) <= aes_out(6);
        elsif phase = 2 or phase = 6 or phase = 12 or phase = 16 then
            aes_in(0) <= aes_out(0);
            aes_in(1) <= aes_out(1);
            aes_in(2) <= aes_out(2) xor aes_out(6);
            aes_in(3) <= aes_out(3);
            aes_in(4) <= aes_out(4);
            aes_in(5) <= aes_out(5) xor aes_out(4);
            aes_in(6) <= aes_out(6) xor aes_out(1);
        elsif phase = 3 or phase = 7 or phase = 13 or phase = 17 then
            aes_in(0) <= aes_out(0);
            aes_in(1) <= aes_out(1) xor aes_out(0);
            aes_in(2) <= aes_out(2);
            aes_in(3) <= aes_out(3);
            aes_in(4) <= aes_out(4) xor aes_out(3);
            aes_in(5) <= aes_out(5);
            aes_in(6) <= aes_out(6);
        elsif phase = 4 then
            if round = 15 then
                if ad_empty = '1' and msg_empty = '1' then
                    aes_in(1) <= aes_out(0) xor z0 xor k0;
                    aes_in(2) <= aes_out(1) xor k1;
                    aes_in(3) <= aes_out(2);
                    aes_in(4) <= aes_out(3) xor z1;
                    aes_in(5) <= aes_out(4) xor k0;
                    aes_in(6) <= aes_out(5) xor k1;
                    aes_in(0) <= aes_out(6);
                else
                    aes_in(1) <= aes_out(0) xor z0;
                    aes_in(2) <= aes_out(1);
                    aes_in(3) <= aes_out(2);
                    aes_in(4) <= aes_out(3) xor z1;
                    aes_in(5) <= aes_out(4) xor k0;
                    aes_in(6) <= aes_out(5) xor k1;
                    aes_in(0) <= aes_out(6);
                end if;
            else
                aes_in(1) <= aes_out(0) xor z0;
                aes_in(2) <= aes_out(1);
                aes_in(3) <= aes_out(2);
                aes_in(4) <= aes_out(3) xor z1;
                aes_in(5) <= aes_out(4);
                aes_in(6) <= aes_out(5);
                aes_in(0) <= aes_out(6);
            end if;
        elsif phase = 8 then
            aes_in(1) <= aes_out(0) xor d0;
            aes_in(2) <= aes_out(1);
            aes_in(3) <= aes_out(2);
            aes_in(4) <= aes_out(3) xor d1;
            aes_in(5) <= aes_out(4);
            aes_in(6) <= aes_out(5);
            aes_in(0) <= aes_out(6);
            if round = 15 and last_block = '1' then
                if msg_empty = '1' then
                    aes_in(1) <= aes_out(0) xor d0 xor k0;
                    aes_in(2) <= aes_out(1) xor k1;
                    aes_in(3) <= aes_out(2);
                    aes_in(4) <= aes_out(3) xor d1;
                    aes_in(5) <= aes_out(4);
                    aes_in(6) <= aes_out(5);
                    aes_in(0) <= aes_out(6);
                end if;
            end if;

        -- forward enc
        elsif phase = 9 then
             aes_in(0) <= aes_out(0);
             aes_in(1) <= aes_out(1);
             aes_in(2) <= aes_out(2) xor aes_out(3);
             aes_in(3) <= aes_out(3);
             aes_in(4) <= aes_out(4);
             aes_in(5) <= aes_out(5);
             aes_in(6) <= aes_out(6) xor aes_out(0);
        -- backward enc
        elsif phase = 10 then
             aes_in(0) <= aes_out(0);
             aes_in(1) <= aes_out(1);
             aes_in(2) <= aes_out(2);
             aes_in(3) <= aes_out(3);
             aes_in(4) <= aes_out(4);
             aes_in(5) <= aes_out(5);
             aes_in(6) <= aes_out(6);
       
        elsif phase = 11 then
             aes_in(0) <= aes_out(0);
             aes_in(1) <= aes_out(1);
             aes_in(2) <= aes_out(2) xor aes_out(3);
             aes_in(3) <= aes_out(3);
             aes_in(4) <= aes_out(4);
             aes_in(5) <= aes_out(5);
             aes_in(6) <= aes_out(6) xor aes_out(4);
        
        elsif phase = 14 then
            aes_in(1) <= aes_out(0) xor d0;
            aes_in(2) <= aes_out(1);
            aes_in(3) <= aes_out(2);
            aes_in(4) <= aes_out(3) xor d1;
            aes_in(5) <= aes_out(4);
            aes_in(6) <= aes_out(5);
            aes_in(0) <= aes_out(6);
            if round = 15 then
                if last_block = '1' then
                    aes_in(1) <= aes_out(0) xor d0 xor k0;
                    aes_in(2) <= aes_out(1) xor k1;
                    aes_in(3) <= aes_out(2);
                    aes_in(4) <= aes_out(3) xor d1;
                    aes_in(5) <= aes_out(4);
                    aes_in(6) <= aes_out(5);
                    aes_in(0) <= aes_out(6);
                end if;
            end if;
        
        else
            aes_in(1) <= aes_out(0) xor ad_len;
            aes_in(2) <= aes_out(1);
            aes_in(3) <= aes_out(2);
            aes_in(4) <= aes_out(3) xor msg_len;
            aes_in(5) <= aes_out(4);
            aes_in(6) <= aes_out(5);
            aes_in(0) <= aes_out(6);
        end if;

    end process;

    --aes_enc_en_mux : process(all)
    --begin
    --    if phase = 1 or phase = 5 or phase = 11 or phase = 15 then
    --        aes_enc_en(0) <= '0';
    --        aes_enc_en(1) <= '0';
    --        aes_enc_en(2) <= '1';
    --        aes_enc_en(3) <= '0';
    --        aes_enc_en(4) <= '0';
    --        aes_enc_en(5) <= '1';
    --        aes_enc_en(6) <= '0';
    --    elsif phase = 2 or phase = 6 or phase = 12 or phase = 16 then
    --        aes_enc_en(0) <= '0';
    --        aes_enc_en(1) <= '1';
    --        aes_enc_en(2) <= '0';
    --        aes_enc_en(3) <= '0';
    --        aes_enc_en(4) <= '1';
    --        aes_enc_en(5) <= '0';
    --        aes_enc_en(6) <= '0';
    --    elsif phase = 3 or phase = 7 or phase = 13 or phase = 17 then
    --        aes_enc_en(0) <= '1';
    --        aes_enc_en(1) <= '0';
    --        aes_enc_en(2) <= '0';
    --        aes_enc_en(3) <= '1';
    --        aes_enc_en(4) <= '0';
    --        aes_enc_en(5) <= '0';
    --        aes_enc_en(6) <= '0';

    --    -- forward enc
    --    elsif phase = 9 then
    --        aes_enc_en(0) <= '0';
    --        aes_enc_en(1) <= '0';
    --        aes_enc_en(2) <= '1';
    --        aes_enc_en(3) <= '0';
    --        aes_enc_en(4) <= '0';
    --        aes_enc_en(5) <= '0';
    --        aes_enc_en(6) <= '1';
    --    -- backward enc
    --    elsif phase = 10 then
    --        aes_dec_en <= '1';
    --    
    --    else
    --        aes_dec_en    <= '0';
    --        aes_enc_en(0) <= '0';
    --        aes_enc_en(1) <= '0';
    --        aes_enc_en(2) <= '0';
    --        aes_enc_en(3) <= '0';
    --        aes_enc_en(4) <= '0';
    --        aes_enc_en(5) <= '0';
    --        aes_enc_en(6) <= '0';
    --    end if;

    --end process;
    
    aes_enc_en_mux : process(all)
    begin
        aes_dec_en0    <= '0'; aes_dec_en1    <= '0';
        aes_enc_en0(0) <= '0'; aes_enc_en1(0) <= '0';
        aes_enc_en0(1) <= '0'; aes_enc_en1(1) <= '0';
        aes_enc_en0(2) <= '0'; aes_enc_en1(2) <= '0';
        aes_enc_en0(3) <= '0'; aes_enc_en1(3) <= '0';
        aes_enc_en0(4) <= '0'; aes_enc_en1(4) <= '0';
        aes_enc_en0(5) <= '0'; aes_enc_en1(5) <= '0';
        aes_enc_en0(6) <= '0'; aes_enc_en1(6) <= '0';
        
        if (phase = 1) or (phase = 15) then
            aes_enc_en0(0) <= '0';
            aes_enc_en0(1) <= '0';
            aes_enc_en0(2) <= '1';
            aes_enc_en0(3) <= '0';
            aes_enc_en0(4) <= '0';
            aes_enc_en0(5) <= '1';
            aes_enc_en0(6) <= '0';
        elsif (phase = 2 and cycle < 12) or (phase = 16 and cycle < 12) then
            aes_enc_en1(0) <= '0';
            aes_enc_en1(1) <= '0';
            aes_enc_en1(2) <= '1';
            aes_enc_en1(3) <= '0';
            aes_enc_en1(4) <= '0';
            aes_enc_en1(5) <= '1';
            aes_enc_en1(6) <= '0';
        end if;

        if (phase = 2) or (phase = 16) then
            aes_enc_en0(0) <= '0';
            aes_enc_en0(1) <= '1';
            aes_enc_en0(2) <= '0';
            aes_enc_en0(3) <= '0';
            aes_enc_en0(4) <= '1';
            aes_enc_en0(5) <= '0';
            aes_enc_en0(6) <= '0';
        elsif (phase = 3 and cycle < 12) or (phase = 17 and cycle < 12) then
            aes_enc_en1(0) <= '0';
            aes_enc_en1(1) <= '1';
            aes_enc_en1(2) <= '0';
            aes_enc_en1(3) <= '0';
            aes_enc_en1(4) <= '1';
            aes_enc_en1(5) <= '0';
            aes_enc_en1(6) <= '0';
        end if;

        if (phase = 3) or (phase = 17) then
            aes_enc_en0(0) <= '1';
            aes_enc_en0(1) <= '0';
            aes_enc_en0(2) <= '0';
            aes_enc_en0(3) <= '1';
            aes_enc_en0(4) <= '0';
            aes_enc_en0(5) <= '0';
            aes_enc_en0(6) <= '0';
        elsif (phase = 4 and cycle < 12) or (phase = 18 and cycle < 12) then
            aes_enc_en1(0) <= '1';
            aes_enc_en1(1) <= '0';
            aes_enc_en1(2) <= '0';
            aes_enc_en1(3) <= '1';
            aes_enc_en1(4) <= '0';
            aes_enc_en1(5) <= '0';
            aes_enc_en1(6) <= '0';
        end if;

        ---- forward enc
        --elsif phase = 9 then
        --    aes_enc_en(0) <= '0';
        --    aes_enc_en(1) <= '0';
        --    aes_enc_en(2) <= '1';
        --    aes_enc_en(3) <= '0';
        --    aes_enc_en(4) <= '0';
        --    aes_enc_en(5) <= '0';
        --    aes_enc_en(6) <= '1';
        ---- backward enc
        --elsif phase = 10 then
        --    aes_dec_en <= '1';
        --
        --else
        --    aes_dec_en    <= '0';
        --    aes_enc_en(0) <= '0';
        --    aes_enc_en(1) <= '0';
        --    aes_enc_en(2) <= '0';
        --    aes_enc_en(3) <= '0';
        --    aes_enc_en(4) <= '0';
        --    aes_enc_en(5) <= '0';
        --    aes_enc_en(6) <= '0';
        --end if;

    end process;

    aes0_gen : entity aes port map (clk, aes_enc_en0(0), aes_enc_en1(0), cycle, round, aes_in(0), aes_out(0));
    aes1_gen : entity aes port map (clk, aes_enc_en0(1), aes_enc_en1(1), cycle, round, aes_in(1), aes_out(1));
    aes2_gen : entity aes port map (clk, aes_enc_en0(2), aes_enc_en1(2), cycle, round, aes_in(2), aes_out(2));
    aes3_gen : entity aes port map (clk, aes_enc_en0(3), aes_enc_en1(3), cycle, round, aes_in(3), aes_out(3));
    aes4_gen : entity aes port map (clk, aes_enc_en0(4), aes_enc_en1(4), cycle, round, aes_in(4), aes_out(4));
    aes5_gen : entity aes port map (clk, aes_enc_en0(5), aes_enc_en1(5), cycle, round, aes_in(5), aes_out(5));
    aes6_gen : entity aes_empty port map (clk, cycle, round, aes_in(6), aes_out(6));

    --
    -- control signals
    --
    cont : entity controller port map (
        clk, reset, last_block, ad_empty, msg_empty, cycle, round, phase
    );

    ct <= (others => '0');


    --
    -- tag generation function
    --
    tg : entity taggen port map (
        aes_out(0), aes_out(1), aes_out(2), aes_out(3), aes_out(4), aes_out(5), aes_out(6), tag
    );

end architecture;
         

