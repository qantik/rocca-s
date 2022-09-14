library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.aes256_gcm_pkg.all;

entity controller is
    port (clk     : in std_logic;
          reset_n : in std_logic;

          start      : in std_logic;
          last_block : in std_logic;

          ad_empty  : in std_logic;
          msg_empty : in std_logic;

          cyclei  : out unsigned(3 downto 0);
          counti  : out unsigned(31 downto 0);
          statei  : out state_type);
end entity;

architecture behavioural of controller is

    signal cycle   : unsigned(3 downto 0);
    signal counter : unsigned(31 downto 0);
    signal state, next_state : state_type;

begin

    cyclei <= cycle;
    statei <= state;
    counti <= counter;

    cycle_reg : process(clk, reset_n)
    begin
        if reset_n = '0' then
            cycle <= "0000";
        elsif rising_edge(clk) then
            if state = hk_state or state = tg_state or state = msg_state then
                cycle <= (cycle + 1) mod 16;
            end if;
        end if;
    end process;
    
    counter_reg : process(clk, reset_n)
    begin
        if reset_n = '0' then
            counter <= (others => '0');
        elsif rising_edge(clk) then
            if (state = hk_state or state = tg_state) and cycle = 15 then
                counter <= (counter + 1);
            elsif (state = msg_state) and cycle = 15 then
                counter <= (counter + r);
            end if;
        end if;
    end process;
    
    state_reg : process(clk, reset_n)
    begin
        if reset_n = '0' then
            state <= idle_state;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process state_reg;

    fsm : process(all)
    begin

        next_state <= state;

        case state is
            when idle_state =>
                next_state <= idle_state;
                if start = '1' then
                    next_state <= hk_state;
                end if;

            when hk_state =>
                next_state <= hk_state;

                if cycle = 15 then
                    next_state <= tg_state;
                end if;

            when tg_state =>
                next_state <= tg_state;

                if cycle = 15 then
                    if ad_empty = '0' then
                        next_state <= ad_state;
                    elsif msg_empty = '0' then
                        next_state <= msg_state;
                    else 
                        next_state <= tag_state;
                    end if;
                end if;

            when ad_state =>
                next_state <= ad_state;

                if last_block = '1' then
                    if msg_empty = '0' then
                        next_state <= msg_state;
                    else
                        next_state <= tag_state;
                    end if;
                end if;
            
            when msg_state =>
                next_state <= msg_state;

                if last_block = '1' and cycle = 15 then
                    next_state <= tag_state;
                end if;


            when tag_state =>
                next_state <= idle_state;
        
        end case;
    end process;

end architecture;
