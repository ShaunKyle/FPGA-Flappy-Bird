LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

entity DrawTest is
  port(
    clk : in std_logic;
    pb0, pb1, pb2 : in std_logic;
    sw : std_logic_vector(9 downto 0);
    mouse_data, mouse_clk : inout std_logic;
    seg0,seg1,seg2,seg3 : out std_logic_vector(6 downto 0);
    seg0_dec,seg1_dec,seg2_dec,seg3_dec : out std_logic;
    LEDG : out std_logic_vector(9 downto 0);
    red_out,green_out,blue_out : out std_logic;
    horiz_sync_out, vert_sync_out : out std_logic
  );
end entity DrawTest;


architecture structure of DrawTest is
  signal clk_25MHz : std_logic;
  signal red,green,blue : std_logic;
  signal red_ball,green_ball,blue_ball : std_logic;
  signal red_ball2,green_ball2,blue_ball2 : std_logic;  --Todo: Make some kind of RGB signal
  signal row,column : std_logic_vector(9 DOWNTO 0);
  signal vert_sync,horiz_sync : std_logic;
  signal text_pixel_out : std_logic;

  signal mouse_btnL, mouse_btnR : std_logic;
  signal mouse_row, mouse_col : std_logic_vector(9 downto 0);

  signal locked_sig : std_logic;  --something to do with PLL output. Don't worry.
begin
  VGA_Display: entity work.vga_sync port map(clk_25MHz,red,green,blue,red_out,green_out,blue_out,horiz_sync,vert_sync,row,column);
  --Object1: entity work.ball port map(clk_25MHz,row,column,red_ball,green_ball,blue_ball);
  --Object2: entity work.bouncy_ball port map('1','1',clk_25MHz,vert_sync,row,column,red_ball,green_ball,blue_ball);
  --Object3: entity work.moving_ball port map(clk_25Mhz,vert_sync,pb1,pb2,row,column,red_ball,green_ball,blue_ball);
  Object3: entity work.moving_ball port map(clk_25Mhz,vert_sync,mouse_btnL,mouse_btnR,row,column,red_ball,green_ball,blue_ball);
  Object4: entity work.position_ball port map(clk_25Mhz,mouse_col,mouse_row,row,column,red_ball2,green_ball2,blue_ball2);

  --Text1: entity work.char_rom port map("000010",row(2 downto 0),column(2 downto 0),clk_25MHz,text_pixel_out);
  Text2: entity work.draw_char port map(clk_25MHz,"000010",32,32,row,column,text_pixel_out);

  Mouse1: entity work.mouse_new_ver port map(clk_25MHz,'0',mouse_data,mouse_clk,mouse_btnL,mouse_btnR,mouse_row,mouse_col);

  SevenSeg0: entity work.seven_seg port map(mouse_row(5 downto 2),seg0);
  SevenSeg1: entity work.seven_seg port map(mouse_row(9 downto 6),seg1);
  SevenSeg2: entity work.seven_seg port map(mouse_col(5 downto 2),seg2);
  SevenSeg3: entity work.seven_seg port map(mouse_col(9 downto 6),seg3);
  seg0_dec <= pb0;
  seg1_dec <= pb1;
  seg2_dec <= '0';
  seg3_dec <= pb2;

  LEDG <= sw;

  vert_sync_out <= vert_sync;
  horiz_sync_out <= horiz_sync;
  red <= (not text_pixel_out) and (red_ball and red_ball2);
  green <= text_pixel_out or (green_ball and green_ball2);
  blue <= (not text_pixel_out) and (blue_ball and blue_ball2);

  --ClockDivider: entity work.clock_div port map(clk, clk_25MHz);
  --Note: Should be using a PLL for VGA display input. Clk divider is just for testing.

  PLL0_inst: entity work.PLL0 PORT MAP (
		areset	 => '0',
		inclk0	 => clk,
		c0	 => clk_25MHz,
		locked	 => locked_sig
	);


end architecture structure;