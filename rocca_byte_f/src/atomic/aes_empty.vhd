library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aes_empty is
    port (clk : in std_logic;

          cycle : in unsigned(3 downto 0);
          round : in unsigned(3 downto 0);

          input  : in  std_logic_vector(7 downto 0);
          output : out std_logic_vector(7 downto 0));
end entity;

architecture behavioural of aes_empty is
   
    -- 15 -> s00, 14 -> s01, 13 -> s02, 12 -> s03 
    -- 11 -> s10, 10 -> s11, 9  -> s12, 8  -> s13 
    -- 7  -> s20, 6  -> s21, 5  -> s22, 4  -> s23 
    -- 3  -> s30, 2  -> s31, 1  -> s32, 0  -> s33 
    type cell is array (15 downto 0) of std_logic_vector(7 downto 0);
    signal state, state_next : cell;

    signal sbox_in, sbox_out : std_logic_vector(7 downto 0);
    signal mix_in, mix_out   : std_logic_vector(31 downto 0);

    procedure swap (variable a, b : inout std_logic_vector(7 downto 0)) is
        variable tmp : std_logic_vector(7 downto 0);
    begin
        tmp := a;
        a   := b;
        b   := tmp;
    end procedure swap;

begin
        
    --output  <= state(15) xor key;
    output  <= state(15);

    reg : process(clk)
    begin
        if rising_edge(clk) then
            state <= state_next;
        end if;
    end process reg;

    pipe : process(all)
        variable head      : std_logic_vector(7 downto 0);
        variable state_tmp : cell;

        variable tmp1, tmp2 : std_logic_vector(7 downto 0);
    begin

        state_tmp := state;
        head := input;

        --if cycle = 15 then
        --    head         := state_tmp(0) xor key;
        --    state_tmp(0) := state_tmp(1);
        --    state_tmp(1) := state_tmp(2);

        --    state_tmp(14) := mix_out(31 downto 24);
        --    state_tmp(10) := mix_out(23 downto 16);
        --    state_tmp(6)  := mix_out(15 downto 8);
        --    state_tmp(2)  := mix_out(7 downto 0);
        -- elsif (cycle = 0 or cycle = 1 or cycle = 2) then
        --    state_tmp(14) := mix_out(31 downto 24);
        --    state_tmp(10) := mix_out(23 downto 16);
        --    state_tmp(6)  := mix_out(15 downto 8);
        --    state_tmp(2)  := mix_out(7 downto 0);

        -- elsif cycle = 8 then
        --    tmp1 := state_tmp(3);

        --    state_tmp(3) := state_tmp(2);
        --    state_tmp(2) := state_tmp(1);
        --    state_tmp(1) := state_tmp(0);
        --    state_tmp(0) := tmp1;
        -- elsif cycle = 12 then
        --    tmp1 := state_tmp(3);
        --    tmp2 := state_tmp(2);

        --    state_tmp(3) := state_tmp(1);
        --    state_tmp(2) := state_tmp(0);
        --    state_tmp(1) := tmp1;
        --    state_tmp(0) := tmp2;
        --end if;

        state_tmp  := state_tmp(14 downto 0) & head;
        state_next <= state_tmp;

    end process pipe;

end architecture;

