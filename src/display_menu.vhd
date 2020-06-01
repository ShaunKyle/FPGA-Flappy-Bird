library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity display_menu is
	port (
    clk : in STD_LOGIC;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);

    cursor_x, cursor_y : in std_logic_vector(9 downto 0);
		
		
		red_out, green_out, blue_out  : OUT STD_LOGIC_VECTOR(3 downto 0)
	);
end entity display_menu;


architecture behaviour of display_menu is

	signal is_option  : BOOLEAN;
	signal is_cursor  : BOOLEAN;

	constant option_X : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(320,10);
	constant option_Y : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(240,10);
	constant option_width_half : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(60,10);
	constant option_height_half : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(20,10);

	constant cursor_width_half : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(5,10);
	constant cursor_height_half : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(5,10);

	--Note: We are using 640x480 pixels

	-- Colors (RRRRGGGGBBBB)
	constant option_color  	   : STD_LOGIC_VECTOR (11 downto 0) := "100101100010";
	constant cursor_color : std_logic_vector(11 downto 0) := "000010001111";
	constant background_color  : STD_LOGIC_VECTOR (11 downto 0) := "111011011000";
begin

	--Draw box with from centre of shape (rather than top-left)
	is_option <= 
		(pixel_column >= option_X - option_width_half) and
		(pixel_column <= option_X + option_width_half) and
		(pixel_row >= option_Y - option_height_half) and
		(pixel_row <= option_Y + option_height_half);

	is_cursor <=
		(pixel_column >= cursor_x - cursor_width_half) and
		(pixel_column <= cursor_x + cursor_width_half) and
		(pixel_row >= cursor_y - cursor_height_half) and
		(pixel_row <= cursor_y + cursor_height_half);

	-- Define current pixel color
	red_out <=
		cursor_color(11 downto 8) when is_cursor=true else
		option_color(11 downto 8) when is_option=true else
		background_color(11 downto 8);

	green_out <=
		cursor_color(7 downto 4) when is_cursor=true else
		option_color(7 downto 4) when is_option=true else
		background_color(7 downto 4);

	blue_out <=
		cursor_color(3 downto 0) when is_cursor=true else
		option_color(3 downto 0) when is_option=true else
		background_color(3 downto 0);

end architecture behaviour;