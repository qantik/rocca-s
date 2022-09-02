library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aes is
    port (clk     : in std_logic;
          reset_n : in std_logic;

          aes_en : in std_logic;
          input  : in  std_logic_vector(7 downto 0);
          output : out std_logic_vector(7 downto 0));
end entity aes;

architecture behavioural of aes is
   
    -- 15 -> s00, 14 -> s01, 13 -> s02, 12 -> s03 
    -- 11 -> s10, 10 -> s11, 9  -> s12, 8  -> s13 
    -- 7  -> s20, 6  -> s21, 5  -> s22, 4  -> s23 
    -- 3  -> s30, 2  -> s31, 1  -> s32, 0  -> s33 
    type cell is array (15 downto 0) of std_logic_vector(7 downto 0);
    signal state, state_next : cell;

    signal sbox_in, sbox_out : std_logic_vector(7 downto 0);
    signal mix_in, mix_out, mix_out1, mix_out2   : std_logic_vector(31 downto 0);
    signal lala, lele   : std_logic_vector(31 downto 0);

    signal inhibit : std_logic_vector(1 downto 0);

    signal enc_cycle  : unsigned(4 downto 0);
    signal enc_en     : std_logic;

    constant zf : std_logic := '1';
    constant zi : std_logic := not zf;
    signal sbox_out1, sbox_out2 : std_logic_vector(7 downto 0);

begin
        
    sbox_in <= input;
    output  <= state(15);

    sbox      : entity work.sbox port map (sbox_in, sbox_out);
    --sbox0      : entity work.sbox_combined port map (sbox_in, zi, sbox_out1);
    --sbox1      : entity work.sbox_combined port map (sbox_out1, zf, sbox_out2);
    --sbox2      : entity work.sbox_combined port map (sbox_out2, zf, sbox_out);
    mixcolumn : entity work.mixcolumn2 port map (mix_in, mix_out);
    --iii       : entity work.invmixcolumn2 port map (mix_in, lala);
    --mixcolumn0 : entity work.mixcolumn2 port map (lala, lele);
    --mixcolumn1 : entity work.mixcolumn2 port map (lele, mix_out2);

    --mix_out <= (others => '0') when mix_out1 /= mix_out2 else mix_out1;

    cycle_reg : process(all)
    begin
        if reset_n = '0' then
            enc_en    <= '0';
            enc_cycle <= (others => '0');
        elsif rising_edge(clk) then
            if aes_en = '1' then
                enc_cycle <= (others => '0');
                enc_en    <= '1';
            elsif enc_en = '1' then
                if enc_cycle < 31 then
                    enc_cycle <= enc_cycle + 1;
                elsif enc_cycle = 31 then
                    enc_en <= '0';
                end if;
            end if;
        end if;
    end process;

    reg : process(clk)
    begin
        if rising_edge(clk) then
            state <= state_next;
        end if;
    end process reg;

    pipe : process(all)
        variable head      : std_logic_vector(7 downto 0);
        variable state_tmp : cell;

        variable tmp1, tmp2, tmp3 : std_logic_vector(7 downto 0);
    begin

        state_tmp := state;
        head      := input;
        mix_in <= state_tmp(14) & state_tmp(13) & state_tmp(12) & state_tmp(11);

        if enc_en = '1' and enc_cycle < 16 then
        --if enable0 = '1' then
            head      := sbox_out;
            -- shift row 1
            --if cycle = 13 then
            if enc_cycle = 13 then
                tmp1 := state_tmp(11);
                state_tmp(11) := state_tmp(7);
                state_tmp(7) := state_tmp(3);
                state_tmp(3) := sbox_out;
                head := tmp1;
            -- shift row 2
             --elsif cycle = 14 then
             elsif enc_cycle = 14 then
                tmp1 := state_tmp(11);
                tmp2 := state_tmp(7);

                state_tmp(11) := state_tmp(3);
                state_tmp(7) := sbox_out;
                state_tmp(3) := tmp1;
                head := tmp2;
            -- shift row 3 and first mc
            --elsif cycle = 15 then
            elsif enc_cycle = 15 then
                tmp1 := state_tmp(11);
                tmp2 := state_tmp(7);
                tmp3 := state_tmp(3);

                state_tmp(11) := sbox_out;
                state_tmp(7) := tmp1;
                state_tmp(3) := tmp2;
                head := tmp3;
        
                mix_in <= state_tmp(14) & state_tmp(13) & state_tmp(12) & sbox_out;
                
                state_tmp(14) := mix_out(31 downto 24); 
                state_tmp(13) := mix_out(23 downto 16); 
                state_tmp(12) := mix_out(15 downto 8); 
                state_tmp(11) := mix_out(7 downto 0); 
            end if;
        end if;
            
        --if enable1 = '1' and (cycle = 3 or cycle = 7 or cycle = 11) then
        if enc_en = '1' and (enc_cycle = 19 or enc_cycle = 23 or enc_cycle = 27) then
            state_tmp(14) := mix_out(31 downto 24); 
            state_tmp(13) := mix_out(23 downto 16); 
            state_tmp(12) := mix_out(15 downto 8); 
            state_tmp(11) := mix_out(7 downto 0); 
        --end if;
        end if;

        state_tmp  := state_tmp(14 downto 0) & head;
        state_next <= state_tmp;

    end process pipe;
    
end architecture behavioural;

