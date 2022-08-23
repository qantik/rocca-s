library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity controller is
    port (clk   : in std_logic;
          reset : in std_logic;

          last_block : in std_logic;
          ad_empty   : in std_logic;
          msg_empty  : in std_logic;

          cycle : out unsigned(3 downto 0);
          round : out unsigned(3 downto 0);
          phase : out unsigned(4 downto 0));
end entity;

architecture behavioural of controller is

    type state_type is (
        load_state, init_state, ad_state, msg_pre_state, msg_post_state, tag_state
    );
    signal state, next_state : state_type;

    signal count   : unsigned(5 downto 0);
    signal round_i : unsigned(3 downto 0);

    signal count_restart : std_logic; 
    signal round_restart : std_logic; 

begin

    cycle <= count(3 downto 0);
    round <= round_i;

    count_restart_comb : process(all)
    begin
        count_restart <= '0';

        if (state = load_state     and count = 15) or
           (state = init_state     and count = 63) or
           (state = ad_state       and count = 63) or
           (state = msg_pre_state  and count = 31) or
           (state = msg_post_state and count = 63) or
           (state = tag_state      and count = 63) then
            count_restart <= '1';
        end if;
    end process;
    
    round_restart_comb : process(all)
    begin
        round_restart <= '0';

        if count = 63 and round_i = 15 then
            if state = init_state or state = tag_state then
                round_restart <= '1';
            end if;
        end if;
    end process;

    phase_comb : process(all)
    begin
        if state = load_state then
            phase <= "00000";

        elsif state = init_state then
            if count < 16 then
                phase <= "00001";
            elsif count >= 16 and count < 32 then
                phase <= "00010";
            elsif count >= 32 and count < 48 then
                phase <= "00011";
            else
                phase <= "00100";
            end if;

        elsif state = ad_state then
            if count < 16 then
                phase <= "00101";
            elsif count >= 16 and count < 32 then
                phase <= "00110";
            elsif count >= 32 and count < 48 then
                phase <= "00111";
            else
                phase <= "01000";
            end if;

        elsif state = msg_pre_state then
            if count < 16 then
                phase <= "01001";
            elsif count >= 16 and count < 32 then
                phase <= "01010";
            end if;

        elsif state = msg_post_state then
            if count < 16 then
                phase <= "01011";
            elsif count >= 16 and count < 32 then
                phase <= "01100";
            elsif count >= 32 and count < 48 then
                phase <= "01101";
            else
                phase <= "01110";
            end if;

        else
            if count < 16 then
                phase <= "01111";
            elsif count >= 16 and count < 32 then
                phase <= "10000";
            elsif count >= 32 and count < 48 then
                phase <= "10001";
            else
                phase <= "10010";
            end if;
        end if;
    end process;
    
    count_reg : process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' or count_restart = '1' then
                count <= (others => '0');
            else 
                count <= count + 1;
            end if;
        end if;
    end process;

    round_reg : process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' or round_restart = '1' then
                round_i <= (others => '0');
            elsif (state = init_state or state = tag_state) and (count = 63) then
                round_i <= round_i + 1;
            end if;
        end if;
    end process;

    state_reg : process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= load_state;
            else 
                state <= next_state;
           end if;
        end if;
    end process state_reg;

    fsm : process(all)
    begin

        next_state <= state;

        case state is

            when load_state =>
                next_state  <= load_state;

                if count = 15 then
                    next_state <= init_state;
                end if;

            when init_state =>
                next_state <= init_state;

                if count = 63 and round_i = 15 then
                    if ad_empty = '0' then
                        next_state <= ad_state;
                    elsif msg_empty = '0' then
                        next_state <= msg_pre_state;
                    else
                        next_state <= tag_state;
                    end if;
                end if;

            when ad_state =>
                next_state <= ad_state;

                if count = 63 and last_block = '1' then
                    if msg_empty = '0' then
                        next_state <= msg_pre_state;
                    else
                        next_state <= tag_state;
                    end if;
                end if;
            
            when msg_pre_state =>
                next_state <= msg_pre_state;

                if count = 31 then
                    next_state <= msg_post_state;
                end if;
                

            when msg_post_state =>
                next_state <= msg_post_state;
                
                if count = 63 then
                    if last_block = '1' then
                        next_state <= tag_state;
                    else
                        next_state <= msg_pre_state;
                    end if;
                end if;

            when tag_state =>
                next_state <= tag_state;
        
        end case;
    end process;

end architecture;
