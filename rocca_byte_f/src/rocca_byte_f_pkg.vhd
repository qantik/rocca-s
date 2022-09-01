library ieee;
use ieee.std_logic_1164.all;

package rocca_byte_f_pkg is
    
    type state_type is (
        idle_state,
        load_state,
        init_state,
        ad_state,
        msg_pre_state,
        msg_post_state,
        tag_state
    );

end package;

