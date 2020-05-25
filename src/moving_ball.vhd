LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity moving_ball is
  port(
    clk, vert_sync : in std_logic;
    btn_up, btn_down : in std_logic;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
    red, green, blue : out std_logic
  );
end entity moving_ball;



architecture behavior of moving_ball is

  SIGNAL ball_on					: std_logic;
  SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
  SIGNAL ball_y_pos				: std_logic_vector(9 DOWNTO 0);
  SiGNAL ball_x_pos				: std_logic_vector(10 DOWNTO 0);
  SIGNAL ball_y_motion			: std_logic_vector(9 DOWNTO 0);
  
  BEGIN           
  
  size <= CONV_STD_LOGIC_VECTOR(8,10);
  -- square_x_pos and square_y_pos show the (x,y) for the left top of square
  ball_x_pos <= CONV_STD_LOGIC_VECTOR(590,11);
  
  ball_on <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
            and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
        '0';
  
  
-- Colours for pixel data on video signal
-- Keeping background white and square in red
Red <=  '1';
-- Turn off Green and Blue when displaying square
Green <= not ball_on;
Blue <=  not ball_on;
  
  
  Move_Ball_vert: process (vert_sync)  	
  begin
    -- Move ball once every vertical sync
    if (rising_edge(vert_sync)) then          --Isn't using rising_edge here bad practice? Replace with edge detector? But it's sort of acting like a clk, so idk.
      -- Move ball up or down with push buttons
      -- Limit ball from going off edge of screen
      --if ((btn_up='0') and ('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(480,10) - size) ) then
      --  ball_y_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
      --elsif ((btn_down='0') and (ball_y_pos <= size)) then 
      --  ball_y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
      --else
      --  ball_y_motion <= "0000000000";
      --end if;

      if (btn_up='1') and (ball_y_pos > size) then
        ball_y_motion <= - CONV_STD_LOGIC_VECTOR(2,10);
      elsif (btn_down='1') and ('0' & ball_y_pos < CONV_STD_LOGIC_VECTOR(480,10) - size) then 
        ball_y_motion <= CONV_STD_LOGIC_VECTOR(2,10);
      else
        ball_y_motion <= "0000000000";
      end if;

      -- Compute next ball Y position
      ball_y_pos <= ball_y_pos + ball_y_motion;
    end if;
  end process Move_Ball_vert;
  
  END behavior;
  
  