library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity menu_display is
	port (
    clk : in STD_LOGIC;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);

    cursor_x, cursor_y : in std_logic_vector(9 downto 0);


		bird_height							: IN STD_LOGIC_VECTOR(9 downto 0);
		pipe1_pos							: IN STD_LOGIC_VECTOR(9 downto 0);
		pipe1_height						: IN STD_LOGIC_VECTOR(9 downto 0);
		
		
		red_out, green_out, blue_out  : OUT STD_LOGIC_VECTOR(3 downto 0)
	);
end entity menu_display;