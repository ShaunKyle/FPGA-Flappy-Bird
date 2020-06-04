library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity pipe is
	 generic (
		starting_pos		  : std_logic_vector(9 downto 0) := "1010000000"
	 );
    port(
		rng_pipe_height 	  : in  std_logic_vector(9 downto 0);
        vert_s, game_started  : in  std_logic;
        reset  				  : in  std_logic;
        pipe_height   		  : out std_logic_vector(9 downto 0);
		pipe_pos              : out std_logic_vector(9 downto 0);
		rng_pipe		      : out std_logic;
		score				  : out std_logic_vector(6 downto 0)
    );
end entity pipe;

architecture behavioural of pipe is
	signal score_s		 : std_logic_vector(6 downto 0) := "0000000";
	signal score_flag    : std_logic := '0';
	signal rng_pipe_s	 : std_logic := '0';
	signal pipe_height_s : std_logic_vector(9 downto 0);
	constant right_edge	 : std_logic_vector(9 downto 0) := "1010100000";
	signal pipe_pos_s  	 : std_logic_vector(9 downto 0) := "0111100000";
	constant bird_X 	 : std_logic_vector(9 downto 0) := "0011000000";
begin
	height_validation: process(rng_pipe_height)
	begin
	if ((rng_pipe_height < CONV_STD_LOGIC_VECTOR(10, 10)) or (rng_pipe_height > CONV_STD_LOGIC_VECTOR(320, 10))) then
		pipe_height_s <= CONV_STD_LOGIC_VECTOR(180, 10);
	else
		pipe_height_s <= rng_pipe_height;
	end if;
	end process;
	 
    process(vert_s, reset, game_started)
    begin
		if (reset = '1') then
			score_s <= CONV_STD_LOGIC_VECTOR(0, 7);
            pipe_pos_s <= starting_pos;
        else
            if (rising_edge(vert_s)) then
				if (game_started = '1') then
					if (pipe_pos_s > "0000000000") then
						rng_pipe_s <= '0';
					    if ((pipe_pos_s < bird_X) and (score_flag <= '0')) then
							score_s <= score_s + CONV_STD_LOGIC_VECTOR(1, 7);
							score_flag <= '1';
						end if;
						pipe_pos_s <= pipe_pos_s - "0000000010";
					else
						score_flag <= '0';
						rng_pipe_s <= '1';
						pipe_pos_s <= right_edge;
					end if;
				end if;
            end if;
        end if;
    end process;
	
	score <= score_s;
    pipe_height <= pipe_height_s;
    pipe_pos <= pipe_pos_s;
	rng_pipe <= rng_pipe_s;

end behavioural;