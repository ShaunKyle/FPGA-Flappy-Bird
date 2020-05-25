LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY rectangle_gen IS
	PORT(
		SIGNAL clk, vert_sync: IN std_logic;
      SIGNAL pixel_row, pixel_column								: IN std_logic_vector(9 DOWNTO 0);
		SIGNAL rec_height													: IN std_logic_vector(9 DOWNTO 0);
		SIGNAL red, green, blue 										: OUT std_logic
	);		
END rectangle_gen;

architecture behavior of rectangle_gen is

SIGNAL rec_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL rec_y_pos				: std_logic_vector(9 DOWNTO 0);
SiGNAL rec_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL rec_y_motion			: std_logic_vector(9 DOWNTO 0);

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(10,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
rec_y_pos <= CONV_STD_LOGIC_VECTOR(320,11);

ball_on <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) )  and (sw0 = '1') else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';


-- Colours for pixel data on video signal
-- Changing the background and ball colour by pushbuttons
Red <=  '1';
Green <= not ball_on or not pb0;
Blue <=  not ball_on or not pb1;

Move_Ball: process (vert_sync, left_button, pb2)
		variable flag : integer := 0;
begin
	-- Move ball every left click
	if (rising_edge(vert_sync)) then			
		if ((left_button = '0' or pb2 = '1') and flag = 1) then
			flag := 0;
      -- on click move ball up a little
      elsif ((left_button = '1' or pb2 = '0') and ('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(25,10) - size) and (flag = 0)) then
			ball_y_motion <= - CONV_STD_LOGIC_VECTOR(10, 10);
			flag := 1;
		-- condition and result
		elsif ( ('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(460,10)) ) then
			ball_y_motion <= "0000000000";
		-- condition and result
		else
			ball_y_motion <= CONV_STD_LOGIC_VECTOR(5,10);
		end if;
		-- Compute next ball Y position
		ball_y_pos <= ball_y_pos + ball_y_motion;
	end if;
end process Move_Ball;

END behavior;
