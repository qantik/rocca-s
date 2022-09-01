library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.rocca_byte_f_pkg.all;

entity rocca_byte_f is
    port (clk     : in std_logic;
          reset_n : in std_logic;
          start   : in std_logic;

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
    signal aes_in  : byte_array (0 to 6);
    signal aes_out : byte_array (0 to 6);
    
    signal counter : unsigned(9 downto 0);
    signal cycle   : unsigned(5 downto 0);
    signal round   : unsigned(3 downto 0);
    signal epoch   : unsigned(1 downto 0);

    signal aes_enc_en : std_logic_vector(0 to 6);
    signal aes_dec_en : std_logic_vector(0 to 6);
    signal state : state_type;
        
begin

    cycle <= counter(5 downto 0);
    round <= counter(9 downto 6);
    epoch <= counter(5) & counter(4);
    --cycle <= resize(counter mod 48, 6);
    --round <= resize(counter / 48, 4);
    --epoch <= cycle(5) & cycle(4);

    k0 <= key(15 downto 8);  k1 <= key(7 downto 0);
    d0 <= data(15 downto 8); d1 <= data(7 downto 0);
    z0 <= z(15 downto 8);    z1 <= z(7 downto 0);

    aes_in_mux : process(all)
        variable k_mask0, k_mask1, d_mask, z_mask, l_mask : std_logic_vector(7 downto 0);
    begin
        k_mask0 := X"FF" when (state = init_state and round = 15 and ad_empty = '1' and msg_empty = '1') or
                              (state = ad_state and last_block = '1'and msg_empty = '1') or
                              (state = msg_post_state and last_block = '1') else X"00";
        k_mask1 := X"FF" when state = init_state and round = 15 else X"00";
        d_mask  := X"FF" when state = ad_state or state = msg_post_state else X"00";
        l_mask  := X"FF" when state = tag_state else X"00";
        z_mask  := X"FF" when state = init_state else X"00";

        aes_in(0) <= k1;
        aes_in(1) <= nonce;
        aes_in(2) <= z0;
        aes_in(3) <= k0;
        aes_in(4) <= z1;
        aes_in(5) <= nonce xor k1;
        aes_in(6) <= (others => '0');

        if state /= load_state then
            
            aes_in(0) <= aes_out(0);
            aes_in(1) <= aes_out(1);
            aes_in(2) <= aes_out(2);
            aes_in(3) <= aes_out(3);
            aes_in(4) <= aes_out(4);
            aes_in(5) <= aes_out(5);
            aes_in(6) <= aes_out(6);

            if epoch = 1 then
                aes_in(2) <= aes_out(2) xor aes_out(6);
                aes_in(5) <= aes_out(5) xor aes_out(4);
                aes_in(6) <= aes_out(6) xor aes_out(1);
            elsif epoch = 2 then
                aes_in(1) <= aes_out(1) xor aes_out(0);
                aes_in(4) <= aes_out(4) xor aes_out(3);
            elsif epoch = 3 then
                aes_in(0) <= aes_out(6);
                aes_in(1) <= aes_out(0) xor (z0 and z_mask) xor (k0 and k_mask0) xor (d0 and d_mask) xor (ad_len and l_mask);
                aes_in(2) <= aes_out(1) xor (k1 and k_mask0);
                aes_in(3) <= aes_out(2);
                aes_in(4) <= aes_out(3) xor (z1 and z_mask) xor (d1 and d_mask) xor (msg_len and l_mask);
                aes_in(5) <= aes_out(4) xor (k0 and k_mask1);
                aes_in(6) <= aes_out(5) xor (k1 and k_mask1);
            end if;
        end if;
    
    end process;

    aes_en_mux : process(all)
    begin
        aes_enc_en <= (others => '0');
        aes_dec_en <= (others => '0');
        
        if state = load_state  then
            if cycle = 15 then
                aes_enc_en(2) <= '1';
                aes_enc_en(5) <= '1';
            end if;
        elsif state = init_state then
            if cycle = 15 then
                aes_enc_en(1) <= '1';
                aes_enc_en(4) <= '1';
            elsif cycle = 31 then
                aes_enc_en(0) <= '1';
                aes_enc_en(3) <= '1';
            elsif cycle = 63 then
                if round = 15 and ad_empty = '1' and msg_empty = '0' then
                    aes_enc_en(2) <= '1';
                    aes_enc_en(5) <= '1';
                else
                    aes_enc_en(2) <= '1';
                    aes_enc_en(5) <= '1';
                end if;
            end if;
        elsif state = ad_state then
            if cycle = 15 then
                aes_enc_en(1) <= '1';
                aes_enc_en(4) <= '1';
            elsif cycle = 31 then
                aes_enc_en(0) <= '1';
                aes_enc_en(3) <= '1';
            elsif cycle = 63 then
                if last_block = '1' and msg_empty = '0' then
                    aes_enc_en(2) <= '1';
                    aes_enc_en(5) <= '1';
                else
                    aes_enc_en(2) <= '1';
                    aes_enc_en(5) <= '1';
                end if;
            end if;
        elsif state = msg_pre_state then
            if cycle = 15 then
                aes_dec_en(3) <= '1';
                aes_dec_en(4) <= '1';
            elsif cycle = 31 then
                aes_enc_en(1) <= '1';
                aes_enc_en(4) <= '1';
            end if;
        elsif state = msg_post_state then
            if cycle = 15 then
                aes_enc_en(1) <= '1';
                aes_enc_en(4) <= '1';
            elsif cycle = 31 then
                aes_enc_en(0) <= '1';
                aes_enc_en(3) <= '1';
            elsif cycle = 63 then
                if last_block = '1' then
                    aes_enc_en(2) <= '1';
                    aes_enc_en(5) <= '1';
                else 
                    aes_enc_en(2) <= '1';
                    aes_enc_en(5) <= '1';
                end if;
            end if;
        elsif state = tag_state then
            if cycle = 15 then
                aes_enc_en(1) <= '1';
                aes_enc_en(4) <= '1';
            elsif cycle = 31 then
                aes_enc_en(0) <= '1';
                aes_enc_en(3) <= '1';
            elsif cycle = 63 then
                aes_enc_en(2) <= '1';
                aes_enc_en(5) <= '1';
            end if;
        end if;
    end process;
    
    aes0_gen : entity work.aes port map (clk, aes_enc_en(0), aes_in(0), aes_out(0));
    aes1_gen : entity work.aes port map (clk, aes_enc_en(1), aes_in(1), aes_out(1));
    aes2_gen : entity work.aes port map (clk, aes_enc_en(2), aes_in(2), aes_out(2));
    aes3_gen : entity work.aes port map (clk, aes_enc_en(3), aes_in(3), aes_out(3));
    aes4_gen : entity work.aes port map (clk, aes_enc_en(4), aes_in(4), aes_out(4));
    aes5_gen : entity work.aes port map (clk, aes_enc_en(5), aes_in(5), aes_out(5));
    aes6_gen : entity work.aes_empty port map (clk, aes_in(6), aes_out(6));

    cont : entity work.controller port map (
        clk, reset_n, start, last_block, ad_empty, msg_empty, counter, state
    );

    ct <= (others => '0');

    tg : entity work.taggen port map (
        aes_out(0), aes_out(1), aes_out(2), aes_out(3), aes_out(4), aes_out(5), aes_out(6), tag
    );

end architecture;
