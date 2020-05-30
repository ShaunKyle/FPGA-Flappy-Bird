LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity position_ball is
  port(
    clk : in std_logic;
    ball_x_pos, ball_y_pos : in std_logic_vector(9 downto 0);
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
    red, green, blue : out std_logic
  );
end entity position_ball;



architecture behavior of position_ball is

  SIGNAL ball_on					: std_logic;
  SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  

BEGIN           
  
  size <= CONV_STD_LOGIC_VECTOR(8,10);
  
  ball_on <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
            and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
        '0';
  
  
  -- Colours for pixel data on video signal
  -- Keeping background white and square in red
  Red <=  '1';
  -- Turn off Green and Blue when displaying square
  Green <= not ball_on;
  Blue <=  not ball_on;
  
END behavior;
  
  