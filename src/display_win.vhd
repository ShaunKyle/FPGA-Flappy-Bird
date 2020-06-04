library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity display_win is
	port (
    clk : in STD_LOGIC;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
		
		red_out, green_out, blue_out  : OUT STD_LOGIC_VECTOR(3 downto 0)
	);
end entity display_win;


architecture behaviour of display_win is

	signal is_string  : BOOLEAN;
	signal is_title 	: BOOLEAN;

	-- signal text_out1,text_out2,text_out3,text_out4,text_out5,text_out6,text_out7,text_out8,text_out9 : std_logic;
	signal t2 : std_logic_vector(3 downto 0);

	

	--Note: We are using 640x480 pixels

	-- Colors (RRRRGGGGBBBB)
	constant title_color : std_logic_vector(11 downto 0) := "111100001011";
	constant background_color  : STD_LOGIC_VECTOR (11 downto 0) := "111011011000";
begin


	--WIN!
	c10: entity work.draw_big_char PORT MAP(clk,"010111",256,224,pixel_row,pixel_column,t2(0));
	c11: entity work.draw_big_char PORT MAP(clk,"001001",288,224,pixel_row,pixel_column,t2(1));
	c12: entity work.draw_big_char PORT MAP(clk,"001110",320,224,pixel_row,pixel_column,t2(2));
	c13: entity work.draw_big_char PORT MAP(clk,"100001",352,224,pixel_row,pixel_column,t2(3));


	is_title <=
		(t2 /= "0000");

	-- Define current pixel color
	red_out <=
		title_color(11 downto 8) when is_title=true else
		background_color(11 downto 8);

	green_out <=
		title_color(7 downto 4) when is_title=true else
		background_color(7 downto 4);

	blue_out <=
		title_color(3 downto 0) when is_title=true else
		background_color(3 downto 0);

end architecture behaviour;