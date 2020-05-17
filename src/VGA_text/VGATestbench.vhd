library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  ieee.std_logic_textio.all;
use  std.textio.all;

entity VGATB is
end VGATB;

architecture test of VGATB is


component VGATest is
	port(
		clk :  IN  STD_LOGIC;
		red_out :  OUT  STD_LOGIC;
		green_out :  OUT  STD_LOGIC;
		blue_out :  OUT  STD_LOGIC;
		horiz_sync_out :  OUT  STD_LOGIC;
		vert_sync_out :  OUT  STD_LOGIC
	);
end component;


signal t_Clk				: std_logic;
signal t_red_out			: std_logic;
signal t_green_out			: std_logic;
signal t_blue_out			: std_logic;
signal t_horiz_sync_out		: std_logic;
signal t_vert_sync_out		: std_logic;

begin

	DUT: VGATest 
	port map(
			clk 			=> t_Clk,			
			red_out 		=> t_red_out,		
			green_out 		=> t_green_out,		
			blue_out 		=> t_blue_out,		
			horiz_sync_out	=> t_horiz_sync_out,
			vert_sync_out 	=> t_vert_sync_out	
			);		

	
	-- clock generation
	clk_gen: process
	begin
		wait for 5 ns;
		t_Clk <= '1';
		wait for 5 ns;
		t_Clk <= '0';
	end process clk_gen;
	
	process (t_Clk)
    --file file_pointer: text is out "write.txt";
	 file file_pointer: text open write_mode is "write.txt";
    variable line_el: line;
	begin

		 if rising_edge(t_Clk) then

			  -- Write the time
			  write(line_el, now); -- write the line.
			  write(line_el, string'(":")); -- write the line.

			  -- Write the hsync
			  write(line_el, string'(" "));
			  write(line_el, t_horiz_sync_out); -- write the line.

			  -- Write the vsync
			  write(line_el, string'(" "));
			  write(line_el, t_vert_sync_out); -- write the line.

			  -- Write the red
			  write(line_el, string'(" "));
			  write(line_el, t_red_out); -- write the line.
			  write(line_el, t_red_out); -- write the line.
			  write(line_el, t_red_out); -- write the line.


			  -- Write the green
			  write(line_el, string'(" "));
			  write(line_el, t_green_out); -- write the line.
			  write(line_el, t_green_out); -- write the line.
			  write(line_el, t_green_out); -- write the line.

			  -- Write the blue
			  write(line_el, string'(" "));
			  write(line_el, t_blue_out); -- write the line.
			  write(line_el, t_blue_out); -- write the line.

			  writeline(file_pointer, line_el); -- write the contents into the file.

		 end if;
	end process;


end test;