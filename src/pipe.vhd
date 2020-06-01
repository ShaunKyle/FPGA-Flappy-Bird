library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity pipe is
    port(
        vert_s, game_started : in std_logic;
        reset  				  : in std_logic;
        pipe_height   		  : out std_logic_vector(9 downto 0);
        pipe_pos             : out std_logic_vector(9 downto 0)
    );
end entity pipe;

architecture behavioural of pipe is
    signal pipe_pos_s    : std_logic_vector(9 downto 0) := "0111100000";
    constant pipe_height_s : std_logic_vector(9 downto 0) := "0011010001";
	 constant right_edge    : std_logic_vector(9 downto 0) := "1010000000";
begin
    process(vert_s, reset, game_started)
    begin
        if (reset = '1') then
            pipe_pos_s <= right_edge;
        else
            if (rising_edge(vert_s)) then
					 if (game_started = '1') then
						 if (pipe_pos_s > "0000000000") then
							  pipe_pos_s <= pipe_pos_s - "0000000010";
						 else
							  pipe_pos_s <= right_edge;
						 end if;
					 end if;
            end if;
        end if;
    end process;
    
    pipe_height <= pipe_height_s;
    pipe_pos <= pipe_pos_s;
end behavioural;