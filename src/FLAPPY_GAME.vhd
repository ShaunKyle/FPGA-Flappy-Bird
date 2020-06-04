LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY FLAPPY_GAME IS 
	PORT
	(
    clk :  IN  STD_LOGIC;
    pb0,pb1,pb2 :  IN  STD_LOGIC;
    sw : in std_logic_vector(9 downto 0);

    mouse_data, mouse_clk : inout std_logic;

    seg0,seg1,seg2,seg3 : out std_logic_vector(6 downto 0);
    seg0_dec,seg1_dec,seg2_dec,seg3_dec : out std_logic;
    LEDG : out std_logic_vector(9 downto 0);
		h_sync :  OUT  STD_LOGIC;
		v_sync :  OUT  STD_LOGIC;
		b_out :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		g_out :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		r_out :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END FLAPPY_GAME;


architecture structure of FLAPPY_GAME is
  --PLL
  signal clk_25 : std_logic;

  --VGA
  signal r,g,b : std_logic_vector(3 downto 0);
  signal r_menu,g_menu,b_menu : std_logic_vector(3 downto 0);
  signal r_game,g_game,b_game : std_logic_vector(3 downto 0);
  signal row,column : std_logic_vector(9 downto 0);
  signal vert_sync, horiz_sync : std_logic;

  --Mouse
  signal mouse_btnL, mouse_btnR : std_logic;
  signal mouse_row, mouse_col : std_logic_vector(9 downto 0);

  --Seven seg
  signal in_seg0,in_seg1,in_seg2,in_seg3 : std_logic_vector(3 downto 0);


  --Game signals
  signal bird_height : std_logic_vector(9 downto 0);
  signal pipe_height, pipe_pos : std_logic_vector(9 downto 0);
  signal game_start : std_logic := '0';
  signal collision : std_logic := '0';

  signal flap_btn,pause_btn : std_logic;

  --Screen signals
  signal screen : std_logic_vector(1 downto 0);

begin
  --
  -- Instantiate interface components. Relevant inputs/outputs are exposed as signal wires.
  --

  inst_PLL: entity work.altpll0 PORT MAP (
		areset	 => '0',
		inclk0	 => clk,
		c0	 => clk_25
		--locked	 => locked_sig
  );

  inst_VGA_sync: entity work.vga_sync PORT MAP (
    clk_25,
    r,g,b,                --Input pixel colour
    r_out,g_out,b_out,
    horiz_sync,vert_sync,
    row,column            --Output current pixel position
  );
  h_sync <= horiz_sync;
  v_sync <= vert_sync;

  inst_Mouse: entity work.mouse_new_ver PORT MAP (
    clk_25,'0',
    mouse_data,mouse_clk,
    mouse_btnL,mouse_btnR,
    mouse_row,mouse_col
  );

  inst_SevenSeg0: entity work.seven_seg port map(in_seg0,seg0);
  inst_SevenSeg1: entity work.seven_seg port map(in_seg1,seg1);
  inst_SevenSeg2: entity work.seven_seg port map(in_seg2,seg2);
  inst_SevenSeg3: entity work.seven_seg port map(in_seg3,seg3);
  

  --
  -- Screen multiplexer
  --
  r <= 
    r_game when (screen = "01") else
    r_menu;
  g <= 
    g_game when (screen = "01") else
    g_menu;
  b <= 
    b_game when (screen = "01") else
    b_menu;

  --
  -- Game
  --

  inst_Display_Game: entity work.display_controller PORT MAP (
    clk_25,
    bird_height,
    pipe_pos,pipe_height,
    row,column,
    r_game,g_game,b_game
  );

  object_Bird: entity work.bird PORT MAP (
    vert_sync,
    collision,
    flap_btn,
    game_start,
    bird_height
  );

  flap_btn <= (not mouse_btnL) and pb2; --Why is it use AND instead of OR? Whatever.


  object_Pipe: entity work.pipe PORT MAP (
    vert_sync,
    game_start,
    collision,
    pipe_height, pipe_pos
  );

  detect_Collision: entity work.collision PORT MAP (
    clk_25,
    bird_height,
    pipe_height, pipe_pos,
    collision
  );

  
  --
  -- Menu
  --

  inst_Display_Menu: entity work.display_menu PORT MAP (
    clk_25,row,column,
    mouse_col,mouse_row,
    r_menu,g_menu,b_menu
  );

  

  --
  -- Do test stuff
  --
  -- r <= "0000";
  -- g <= "1111";
  -- b <= "0000";

  in_seg0 <= mouse_row(5 downto 2);
  in_seg1 <= mouse_row(9 downto 6);
  in_seg2 <= mouse_col(5 downto 2);
  in_seg3 <= mouse_col(9 downto 6);

  seg0_dec <= pb0;
  seg1_dec <= pb1;
  seg2_dec <= '0';
  seg3_dec <= pb2;

  LEDG <= sw;



end architecture structure;