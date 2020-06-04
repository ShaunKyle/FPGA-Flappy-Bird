library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity display_controller is
	generic (
		pipe_gap : STD_LOGIC_VECTOR (9 downto 0) := "0001100111"
	);
	port (
		clk_25								: IN STD_LOGIC;
		bird_height							: IN STD_LOGIC_VECTOR(9 downto 0);
		pipe1_pos							: IN STD_LOGIC_VECTOR(9 downto 0);
		pipe1_height						: IN STD_LOGIC_VECTOR(9 downto 0);
		pipe2_pos							: IN STD_LOGIC_VECTOR(9 downto 0);
		pipe2_height						: IN STD_LOGIC_VECTOR(9 downto 0);
		pixel_row, pixel_column			: IN STD_LOGIC_VECTOR(9 downto 0);
		
		red_out, green_out, blue_out  : OUT STD_LOGIC_VECTOR(3 downto 0)
	);
end entity display_controller;

architecture behavioural of display_controller is

	signal is_bird  : BOOLEAN; 
	signal is_grass : BOOLEAN; 
	signal is_bar   : BOOLEAN; 
	signal is_pipe1 : BOOLEAN; 
	signal is_pipe2 : BOOLEAN;

	constant bird_X 	: STD_LOGIC_VECTOR (9 downto 0) := "0011000000"; -- X position of the bird
	constant bird_size  : STD_LOGIC_VECTOR (9 downto 0) := "0000010000"; -- Size of the bird
	constant sky_height : STD_LOGIC_VECTOR (9 downto 0) := "0110101111"; -- Size of the sky
	constant bar_height : STD_LOGIC_VECTOR (9 downto 0) := "0000000100"; -- Size of the bar
	constant pipe_width : STD_LOGIC_VECTOR (9 downto 0) := "0000100000"; -- Width of one pipe

	-- Colors (RRRRGGGGBBBB)
	constant bird_color  	   : STD_LOGIC_VECTOR (11 downto 0) := "111100000000";
	constant grass_color 	   : STD_LOGIC_VECTOR (11 downto 0) := "000011111111";
	constant bar_color   	   : STD_LOGIC_VECTOR (11 downto 0) := "000001110011";
	constant pipe_color  	   : STD_LOGIC_VECTOR (11 downto 0) := "000000001111";
	constant background_color  : STD_LOGIC_VECTOR (11 downto 0) := "111011011000";

begin
  -- Test areas
  is_bird  <= (pixel_column >= bird_X) and
				  (pixel_column <= bird_X + bird_size) and
				  (pixel_row >= bird_height) and
				  (pixel_row <= bird_height + bird_size);
				 
  is_pipe1 <= (pixel_column + pipe_width > pipe1_pos) and
				  (pixel_column + pipe_width < pipe1_pos + pipe_width) and
				  ((pixel_row < pipe1_height) or
				  (pixel_row > pipe1_height + pipe_gap));
  
  is_pipe2 <= (pixel_column + pipe_width > pipe2_pos) and
				  (pixel_column + pipe_width < pipe2_pos + pipe_width) and
				  ((pixel_row < pipe2_height) or
				  (pixel_row > pipe2_height + pipe_gap));
				  
  is_grass <=  pixel_row > sky_height + bar_height;
  
  is_bar   <=  pixel_row > sky_height;

  -- Define current pixel color depending on the state of the game
	red_out <=    bird_color(11 downto 8)  when is_bird=true  						  else
					  grass_color(11 downto 8) when is_grass=true 						  else
					  bar_color(11 downto 8)   when is_bar=true   						  else
					  pipe_color(11 downto 8)  when (is_pipe1=true or is_pipe2=true) else
					  background_color(11 downto 8);
	
	green_out <=  bird_color(7 downto 4)   when is_bird=true  						  else
					  grass_color(7 downto 4)  when is_grass=true 						  else
					  bar_color(7 downto 4)    when is_bar=true   						  else
					  pipe_color(7 downto 4)   when (is_pipe1=true or is_pipe2=true) else
				     background_color(7 downto 4);
	
	blue_out <=   bird_color(3 downto 0)   when is_bird=true  						  else
					  grass_color(3 downto 0)  when is_grass=true 						  else
					  bar_color(3 downto 0)    when is_bar=true   						  else
					  pipe_color(3 downto 0)   when (is_pipe1=true or is_pipe2=true) else
					  background_color(3 downto 0);
end behavioural; 