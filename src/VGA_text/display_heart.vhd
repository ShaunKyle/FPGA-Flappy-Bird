LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity heart is
	port (
		clock : IN std_logic;
		pixel_row, pixel_col, mouse_col : IN std_logic_vector(9 downto 0);
		RGB_out	: OUT std_logic_vector(15 downto 0)
	);
end entity heart;

architecture arch of heart is
	signal x : std_logic_vector(9 downto 0);
	signal y : std_logic_vector(9 downto 0);
begin
	x <= CONV_STD_LOGIC_VECTOR(32, 10);
	y <= CONV_STD_LOGIC_VECTOR(420, 10);
	output_drawing : entity work.draw_object generic map ("images/heart.mif", 32, 32) 
		port map(clock, pixel_row, pixel_col, x, y, RGB_out);
end architecture arch;