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

    LEDG          : OUT std_logic_vector(9 downto 0);
		h_sync        : OUT STD_LOGIC;
		v_sync        : OUT STD_LOGIC;
		b_out         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		g_out         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    r_out         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    display_tens  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    display_ones  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
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
  signal bird_height 				                : std_logic_vector(9 downto 0);
  signal pipe1_height, pipe1_pos            : std_logic_vector(9 downto 0);
  signal pipe2_height, pipe2_pos            : std_logic_vector(9 downto 0);
  signal game_start                         : std_logic := '0';
  signal collision                          : std_logic := '0';
  signal rng_pipe_height1, rng_pipe_height2 : std_logic_vector(9 downto 0);
  signal rng_pipe1, rng_pipe2               : std_logic;
  signal flap_btn,pause_btn                 : std_logic;
  
  signal new_score								          : integer;
  signal score_enable1, score_enable2       : std_logic;
  
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

  --
  -- Screen multiplexer
  --
  r <= 
    r_game when (true) else
    r_menu;
  g <= 
    g_game when (true) else
    g_menu;
  b <= 
    b_game when (true) else
    b_menu;

  --
  -- Game
  --

  inst_Display_Game: entity work.display_controller 
  GENERIC MAP (
    pipe_gap => "0001100111"
  )
  PORT MAP (
    clk_25,
    bird_height,
    pipe1_pos,pipe1_height,
    pipe2_pos,pipe2_height,
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

  object_Pipe1: entity work.pipe
  GENERIC MAP (
    starting_pos => "1010000000"
  )
  PORT MAP (
    rng_pipe_height1,
    vert_sync,
    game_start,
    collision,
    pipe1_height, pipe1_pos,
    rng_pipe1,
    score_enable1
  );

  object_Pipe2: entity work.pipe
  GENERIC MAP (
    starting_pos => "1111000000"
  )
  PORT MAP (
    rng_pipe_height2,
    vert_sync,
    game_start,
    collision,
    pipe2_height, pipe2_pos,
    rng_pipe2,
    score_enable2
  );
  
  detect_Collision: entity work.collision PORT MAP (
    clk_25,
    bird_height,
    pipe1_height, pipe1_pos,
    pipe2_height, pipe2_pos,
    collision
  );

  random_Number_Generator1: entity work.lfsr PORT MAP (
    clk_25,
    rng_pipe1,
    rng_pipe_height1
  );
  
  random_Number_Generator2: entity work.lfsr PORT MAP (
    clk_25,
    rng_pipe2,
    rng_pipe_height2
  );

  score_Keeper: entity work.score PORT MAP (
    collision,
    new_score,
    score_enable1 or score_enable2,
    new_score
  );

  score_Display: entity work.seven_seg PORT MAP (
    new_score,
    display_tens,
    display_ones
  );
  
  --
  -- Menu
  --
  inst_Display_Menu: entity work.display_menu PORT MAP (
    clk_25,row,column,
    mouse_col,mouse_row,
    r_menu,g_menu,b_menu
  );

end architecture structure;