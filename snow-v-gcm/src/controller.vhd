library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.snow_gcm_pkg.all;

entity controller is
    port (clk     : in std_logic;
          reset_n : in std_logic;

          start      : in std_logic;
          last_block : in std_logic;

          ad_empty  : in std_logic;
          msg_empty : in std_logic;

          cyclei  : out unsigned(4 downto 0);
          statei  : out state_type);
end entity;

architecture behavioural of controller is

    signal cycle   : unsigned(4 downto 0);
    signal counter : unsigned(31 downto 0);
    signal state, next_state : state_type;

begin

    cyclei <= cycle;
    statei <= state;

    cycle_reg : process(clk, reset_n)
    begin
        if reset_n = '0' then
            cycle <= "00000";
        elsif rising_edge(clk) then
            if state = load_state and cycle < 18 then
                cycle <= (cycle + 1);
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
                    next_state <= load_state;
                end if;

            when load_state =>
                next_state <= load_state;

                if cycle = (18/r) then
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

                if last_block = '1' then
                    next_state <= tag_state;
                end if;

            when tag_state =>
                next_state <= idle_state;
        
        end case;
    end process;

end architecture;
