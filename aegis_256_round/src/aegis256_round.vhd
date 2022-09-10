library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.aegis256_round_pkg.all;

entity aegis256_round is
    generic (rf_conf : rf_t_enum := rf_split_e;
	         sb_conf : sb_t_enum := sb_fast_e;
	         mc_conf : mc_t_enum := mc_fast_e);
    port (clk     : in std_logic;
          reset_n : in std_logic;

          iv  : in std_logic_vector(255 downto 0);
          key : in std_logic_vector(255 downto 0);
          
          start      : in std_logic; 
          last_block : in std_logic;
          
          data      : in std_logic_vector(128*r-1 downto 0);
          ad_len    : in std_logic_vector(63 downto 0);
          ad_empty  : in std_logic;
          msg_len   : in std_logic_vector(63 downto 0);
          msg_empty : in std_logic;
          
          ct        : out std_logic_vector(128*r-1 downto 0);
          tag       : out std_logic_vector(127 downto 0));
end entity;

architecture structural of aegis256_round is

    signal k0, k1   : std_logic_vector(127 downto 0);
    signal iv0, iv1 : std_logic_vector(127 downto 0);
    
    signal state : state_type;
    signal cycle : unsigned(4 downto 0);

    signal sr_load : state_t_arr;
    signal sr_in   : state_t_arr;
    signal sr_out  : state_t_arr;

    signal tr_load : std_logic;
    signal tr_in   : std_logic_vector(127 downto 0);
    signal tr_out  : std_logic_vector(127 downto 0);

    signal ru_aux : std_logic_vector(128*r-1 downto 0);
    
    signal length : std_logic_vector(127 downto 0);
    constant c0   : std_logic_vector(127 downto 0) := X"000101020305080D1522375990E97962";
    constant c1   : std_logic_vector(127 downto 0) := X"DB3D18556DC22FF12011314273B528DD";

    type ru_inter_t_arr is array (0 to r) of state_t_arr;
    signal ru_inter : ru_inter_t_arr;

begin

    k0  <= key(255 downto 128);
    k1  <= key(127 downto 0);
    iv0 <= iv(255 downto 128);
    iv1 <= iv(127 downto 0);
   
    -- shfit length by seven positions (x 128)
    length <= ad_len(56 downto 0) & "0000000" & msg_len(56 downto 0) & "0000000";

    sr_load(0) <= k0 xor iv0;
    sr_load(1) <= k1 xor iv1;
    sr_load(2) <= c1;
    sr_load(3) <= c0;
    sr_load(4) <= k0 xor c0;
    sr_load(5) <= k1 xor c1;

    ru_aux_gen0 : if r = 1 generate
        ru_aux(127 downto 0) <= k0 when state = init_state and cycle mod 4 = 0 else
                  k1               when state = init_state and cycle mod 4 = 1 else
                  k0 xor iv0       when state = init_state and cycle mod 4 = 2 else
                  k1 xor iv1       when state = init_state and cycle mod 4 = 3 else
                  tr_in            when state = tag_state  and cycle = 16 else
                  tr_out           when state = tag_state  and cycle > 16 else
                  data(127 downto 0);
        sr_in <= ru_inter(r);
    end generate;
    ru_aux_gen1 : if r = 2 generate
        ru_aux(127 downto 0) <= k0 when state = init_state and cycle mod 2 = 0 else
                  k0 xor iv0       when state = init_state and cycle mod 2 = 1 else
                  tr_in            when state = tag_state  and cycle = 8 else
                  tr_out           when state = tag_state  and cycle > 8 else
                  data(127 downto 0);
        ru_aux(255 downto 128) <= k1 when state = init_state and cycle mod 2 = 0 else
                  k1 xor iv1         when state = init_state and cycle mod 2 = 1 else
                  tr_in              when state = tag_state  and cycle = 8 else
                  tr_out             when state = tag_state  and cycle > 8 else
                  data(255 downto 128);
        sr_in <= ru_inter(r-1) when state = tag_state and cycle = 11 else ru_inter(r);
    end generate;

    tr_in   <= sr_out(3) xor length;
    tr_load <= '1' when state = tag_state and cycle = (16/r) else '0';

    tr : entity taux_reg port map (clk, reset_n, tr_load, tr_in, tr_out);

    s0_reg : entity state_reg port map (clk, reset_n, start, sr_load(0), sr_in(0), sr_out(0));
    s1_reg : entity state_reg port map (clk, reset_n, start, sr_load(1), sr_in(1), sr_out(1));
    s2_reg : entity state_reg port map (clk, reset_n, start, sr_load(2), sr_in(2), sr_out(2));
    s3_reg : entity state_reg port map (clk, reset_n, start, sr_load(3), sr_in(3), sr_out(3));
    s4_reg : entity state_reg port map (clk, reset_n, start, sr_load(4), sr_in(4), sr_out(4));
    s5_reg : entity state_reg port map (clk, reset_n, start, sr_load(5), sr_in(5), sr_out(5));
  
    ru_inter(0) <= sr_out;
    ru_gen : for i in 0 to (r-1) generate
        ru : entity roundupdate generic map (rf_conf, sb_conf, mc_conf) port map (
            ru_inter(i), ru_inter(i+1), ru_aux(128*(i+1)-1 downto 128*i)
        );
    end generate;

    cont : entity controller port map (
        clk, reset_n, start, last_block, ad_empty, msg_empty, cycle, state
    );

    ct_gen : for i in 0 to (r-1) generate
        f0_gen : entity f0 port map(
            ru_inter(i+1), data(128*(i+1)-1 downto 128*i), ct(128*(i+1)-1 downto 128*i)
        );
    end generate;
    
    tg     : entity taggen port map (sr_out, tag);

end architecture;

