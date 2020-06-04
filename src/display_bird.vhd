LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity disp_bird is
	port (
		clk_25 				  : IN std_logic;
		pixel_row, pixel_col  : IN std_logic_vector(9 downto 0);
		bird_height			  : IN std_logic_vector(9 downto 0);
		bird_rgb			  : OUT std_logic_vector(11 downto 0)
	);
end entity disp_bird;

architecture arch of disp_bird is
	constant bird_X 	: STD_LOGIC_VECTOR (9 downto 0) := "0011000000"; -- X position of the bird

	signal x : std_logic_vector(9 downto 0);
	signal y : std_logic_vector(9 downto 0);
begin
	output_drawing : entity work.image_draw generic map ("../Images/parrot.mif", 16, 16) 
		port map(clk_25, pixel_row, pixel_col, bird_X, bird_height, bird_rgb);
end architecture arch;