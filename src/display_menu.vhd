library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity display_menu is
	port (
    clk : in STD_LOGIC;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);

    cursor_x, cursor_y : in std_logic_vector(9 downto 0);
		cursor_btnL : in std_logic;
		

		
		red_out, green_out, blue_out  : OUT STD_LOGIC_VECTOR(3 downto 0)
	);
end entity display_menu;


architecture behaviour of display_menu is

	signal is_option  : BOOLEAN;
	signal is_cursor  : BOOLEAN;
	signal is_string  : BOOLEAN;
	signal is_title 	: BOOLEAN;

	signal text_out1,text_out2,text_out3,text_out4,text_out5,text_out6,text_out7,text_out8,text_out9 : std_logic;
	signal t1 : std_logic_vector(8 downto 0);
	signal t2 : std_logic_vector(3 downto 0);

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
	constant text_color : std_logic_vector(11 downto 0) := "000000000000";
	constant menu_color : std_logic_vector(11 downto 0) := "111110110000";
	constant background_color  : STD_LOGIC_VECTOR (11 downto 0) := "111011011000";
begin
	--SW0-LEVEL
	-- char1: entity work.draw_char PORT MAP (clk,"010000",160,208,pixel_row,pixel_column,text_out1);
	-- char2: entity work.draw_char PORT MAP (clk,"000010",176,208,pixel_row,pixel_column,text_out2);
	char1: entity work.draw_char PORT MAP (clk,"010011",160,208,pixel_row,pixel_column,text_out1);
	char2: entity work.draw_char PORT MAP (clk,"010111",176,208,pixel_row,pixel_column,text_out2);
	char3: entity work.draw_char PORT MAP (clk,"110000",192,208,pixel_row,pixel_column,text_out3);
	char4: entity work.draw_char PORT MAP (clk,"101101",208,208,pixel_row,pixel_column,text_out4);
	char5: entity work.draw_char PORT MAP (clk,"001100",224,208,pixel_row,pixel_column,text_out5);
	char6: entity work.draw_char PORT MAP (clk,"000101",240,208,pixel_row,pixel_column,text_out6);
	char7: entity work.draw_char PORT MAP (clk,"010110",256,208,pixel_row,pixel_column,text_out7);
	char8: entity work.draw_char PORT MAP (clk,"000101",272,208,pixel_row,pixel_column,text_out8);
	char9: entity work.draw_char PORT MAP (clk,"001100",288,208,pixel_row,pixel_column,text_out9);

	--SW1-TRAIN
	c1: entity work.draw_char PORT MAP (clk,"010011",160,272,pixel_row,pixel_column,t1(0));
	c2: entity work.draw_char PORT MAP (clk,"010111",176,272,pixel_row,pixel_column,t1(1));
	c3: entity work.draw_char PORT MAP (clk,"110001",192,272,pixel_row,pixel_column,t1(2));
	c4: entity work.draw_char PORT MAP (clk,"101101",208,272,pixel_row,pixel_column,t1(3));
	c5: entity work.draw_char PORT MAP (clk,"010100",224,272,pixel_row,pixel_column,t1(4));
	c6: entity work.draw_char PORT MAP (clk,"010010",240,272,pixel_row,pixel_column,t1(5));
	c7: entity work.draw_char PORT MAP (clk,"000001",256,272,pixel_row,pixel_column,t1(6));
	c8: entity work.draw_char PORT MAP (clk,"001001",272,272,pixel_row,pixel_column,t1(7));
	c9: entity work.draw_char PORT MAP (clk,"001110",288,272,pixel_row,pixel_column,t1(8));

	--MENU
	c10: entity work.draw_big_char PORT MAP(clk,"001101",256,32,pixel_row,pixel_column,t2(0));
	c11: entity work.draw_big_char PORT MAP(clk,"000101",288,32,pixel_row,pixel_column,t2(1));
	c12: entity work.draw_big_char PORT MAP(clk,"001110",320,32,pixel_row,pixel_column,t2(2));
	c13: entity work.draw_big_char PORT MAP(clk,"010101",352,32,pixel_row,pixel_column,t2(3));


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

	is_string <=
		(text_out1 = '1') or
		(text_out2 = '1') or
		(text_out3 = '1') or
		(text_out4 = '1') or
		(text_out5 = '1') or
		(text_out6 = '1') or
		(text_out7 = '1') or
		(text_out8 = '1') or
		(text_out9 = '1') or
		(t1 /= "000000000");
	
	is_title <=
		(t2 /= "0000");

	-- Define current pixel color
	red_out <=
		cursor_color(11 downto 8) when is_cursor=true else
		--option_color(11 downto 8) when is_option=true else
		text_color(11 downto 8) when is_string=true else
		menu_color(11 downto 8) when is_title=true else
		background_color(11 downto 8);

	green_out <=
		cursor_color(7 downto 4) when is_cursor=true else
		--option_color(7 downto 4) when is_option=true else
		text_color(7 downto 4) when is_string=true else
		menu_color(7 downto 4) when is_title=true else
		background_color(7 downto 4);

	blue_out <=
		cursor_color(3 downto 0) when is_cursor=true else
		--option_color(3 downto 0) when is_option=true else
		text_color(3 downto 0) when is_string=true else
		menu_color(3 downto 0) when is_title=true else
		background_color(3 downto 0);

end architecture behaviour;