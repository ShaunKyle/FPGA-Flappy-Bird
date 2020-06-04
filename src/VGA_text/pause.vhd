library ieee;
use ieee.std_logic_1164.all;
use  ieee.std_logic_arith.all;
use  ieee.std_logic_unsigned.all;
library lpm;
use lpm.lpm_components.all;

package de0core1 is
	component vga_sync
 		port(clock_25mhz : in std_logic; 
				red, green, blue	: in	std_logic_vector(3 downto 0);
         	red_out, green_out, blue_out	: out 	std_logic_vector(9 downto 0);
			horiz_sync_out, vert_sync_out	: out std_logic;
			pixel_row, pixel_column			: out std_logic_vector(10 downto 0));
	end component;
end de0core1;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
library work;
use work.de0core1.all;

entity pause_disp is
	port(signal pb0, pb1, clock 			: in std_logic;
		signal bg_input : in std_logic_vector(11 downto 0);
        signal red, green, blue			: out std_logic_vector(9 downto 0);
        signal horiz_sync,vert_sync		: out std_logic;
		signal row, col			: out std_logic_vector(10 downto 0));
end entity pause_disp;

architecture behavioural of pause_disp is

	signal row_sel : std_logic_vector(2 downto 0);
	signal col_sel : std_logic_vector(2 downto 0);
	signal char_address : std_logic_vector(5 downto 0) := "000000";
	signal character_address : std_logic_vector (5 downto 0);
	signal char_out : std_logic;
	signal char_disp : std_logic;
	
	
-- vga display signals   
signal vert_sync_int : std_logic;
signal red_data, green_data, blue_data : std_logic_vector(3 downto 0);
signal pixel_row, pixel_column				: std_logic_vector(10 downto 0); 

	component char_rom
		port(character_address	:	in std_logic_vector (5 downto 0);
		font_row, font_col	:	in std_logic_vector (2 downto 0);
		clock				: 	in std_logic ;
		rom_mux_output		:	out std_logic);
end component;
begin

	sync: vga_sync
 		port map(clock_25mhz => clock, 
				red => red_data, green => green_data, blue => blue_data,	
    	     	red_out => red, green_out => green, blue_out => blue,
			 	horiz_sync_out => horiz_sync, vert_sync_out => vert_sync_int,
			 	pixel_row => pixel_row, pixel_column => pixel_column);
				
	char: char_rom
		port map(clock => clock, character_address => char_address, 
			font_row => row_sel,
			font_col => col_sel,
			rom_mux_output => char_out);
			
	vert_sync <= vert_sync_int;

			
red_data <= "0000" when (char_out = '1') and (char_disp = '1') 
		else bg_input(11 downto 8);
		
green_data <= "0000" when (char_out = '1') and (char_disp = '1') 
		else bg_input(7 downto 4);
		
blue_data <= "0000" when (char_out = '1') and (char_disp = '1')
		else bg_input(3 downto 0);

row <= pixel_row;
col <= pixel_column;

text_display: process (pixel_column, pixel_row)
begin
  ---pause
	if((pixel_row >= conv_std_logic_vector(224,11)) and (pixel_row < conv_std_logic_vector(256,11))) then 
		if((pixel_column >= conv_std_logic_vector(224,11)) and (pixel_column < conv_std_logic_vector(256,11))) then
				char_address <= "010000"; --p
				row_sel <= pixel_row(5 downto 3);
				col_sel <= pixel_column(5 downto 3);
				char_disp <= '1';
		elsif((pixel_column >= conv_std_logic_vector(256,11)) and (pixel_column < conv_std_logic_vector(288,11))) then
				char_address <= "000001"; --a
				row_sel <= pixel_row(5 downto 3);
				col_sel <= pixel_column(5 downto 3);
				char_disp <= '1';
		elsif((pixel_column >= conv_std_logic_vector(288,11)) and (pixel_column < conv_std_logic_vector(320,11))) then
				char_address <= "010101"; --u
				row_sel <= pixel_row(5 downto 3);
				col_sel <= pixel_column(5 downto 3);
				char_disp <= '1';
		elsif((pixel_column >= conv_std_logic_vector(320,11)) and (pixel_column < conv_std_logic_vector(352,11))) then
				char_address <= "010011"; --s
				row_sel <= pixel_row(5 downto 3);
				col_sel <= pixel_column(5 downto 3);
				char_disp <= '1';
		elsif((pixel_column >= conv_std_logic_vector(352,11)) and (pixel_column < conv_std_logic_vector(384,11))) then
				char_address <= "000101"; --e
				row_sel <= pixel_row(5 downto 3);
				col_sel <= pixel_column(5 downto 3);
				char_disp <= '1';
		end if;
	else --how to do the print and then set to 0 at end. 
		--reset the char rom mux
		row_sel <= "000";
		col_sel <= "000";
		char_address <= "000000";
		char_disp <= '0';
	end if;
end process text_display;
end behavioural; 

--- could loop through each letter, with each letters character address stored as well. 
