library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity collision is
	port(
		clk_25      : in std_logic;
		bird_height : in std_logic_vector(9 downto 0);
		pipe_height : in std_logic_vector(9 downto 0);
		pipe_pos    : in std_logic_vector(9 downto 0);
		reset			: out std_logic
	);
end entity collision;

architecture behavioural of collision is
	constant bird_X 	   : STD_LOGIC_VECTOR (9 downto 0) := "0011000000"; -- X position of the bird
constant bird_size  : STD_LOGIC_VECTOR (9 downto 0) := "0000010000"; -- Size of the bird
constant sky_height : STD_LOGIC_VECTOR (9 downto 0) := "0110101111"; -- Size of the sky
constant bar_height : STD_LOGIC_VECTOR (9 downto 0) := "0000000100"; -- Size of the bar
constant pipe_width : STD_LOGIC_VECTOR (9 downto 0) := "0000100000"; -- Width of one pipe
constant pipe_gap   : STD_LOGIC_VECTOR (9 downto 0) := "0001100000"; -- Gap between two pipes
	
	signal groundOkay : BOOLEAN;
	signal pipeOkay   : BOOLEAN;
begin
	groundOkay <= (bird_height < sky_height - bar_height);
	pipeOkay <= (pipe_pos < bird_X) or -- pipe is before
					(pipe_pos > bird_X + bird_size + pipe_width) or -- pipe is after
               ((bird_height > pipe_height) and
               (bird_height + bird_size < pipe_height + pipe_gap)); -- bird is in pipe gap
	reset <= '0' when groundOkay and pipeOkay else '1' when rising_edge(clk_25);
end behavioural;
	