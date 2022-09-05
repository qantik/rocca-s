library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.rocca_byte_f_pkg.all;

entity controller is
    port (clk     : in std_logic;
          reset_n : in std_logic;
          start   : in std_logic;

          last_block : in std_logic;
          ad_empty   : in std_logic;
          msg_empty  : in std_logic;

          counter : out unsigned(9 downto 0);
          state   : out state_type);
end entity;

architecture behavioural of controller is

    signal next_state : state_type;

    signal cycle : unsigned(5 downto 0);
    signal round : unsigned(3 downto 0);

begin

    cycle <= counter(5 downto 0);
    round <= counter(9 downto 6);

    counter_reg : process(all)
    begin
        if rising_edge(clk) then
            if start = '1' then
                counter <= (others => '0');
            elsif state = load_state then
                counter <= (counter + 1) mod 16;
            elsif state = ad_state or state = msg_post_state then
                counter <= (counter + 1) mod 64;
            elsif state = init_state or state = tag_state then
                counter <= (counter + 1) mod 1024; -- 1024
            elsif state = msg_pre_state then
                counter <= (counter + 1) mod 32;
            end if;
        end if;
    end process;
    
    state_reg : process(clk)
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
                    next_state <= load_state;
                end if;

            when load_state =>
                next_state  <= load_state;

                if counter = 15 then
                    next_state <= init_state;
                end if;

            when init_state =>
                next_state <= init_state;

                if cycle = 63 and round = 15 then
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

                if cycle = 63 and last_block = '1' then
                    if msg_empty = '0' then
                        next_state <= msg_pre_state;
                    else
                        next_state <= tag_state;
                    end if;
                end if;
            
            when msg_pre_state =>
                next_state <= msg_pre_state;

                if cycle = 31 then
                    next_state <= msg_post_state;
                end if;
                

            when msg_post_state =>
                next_state <= msg_post_state;
                
                if cycle = 63 then
                    if last_block = '1' then
                        next_state <= tag_state;
                    else
                        next_state <= msg_pre_state;
                    end if;
                end if;

            when tag_state =>
                next_state <= tag_state;
                if cycle = 63 and round = 15 then
                    next_state <= idle_state;
                end if;
        
        end case;
    end process;

end architecture;
