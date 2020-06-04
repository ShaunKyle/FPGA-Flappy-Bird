LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

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
  signal game_over                          : std_logic := '0';
  signal bird_height 				                : std_logic_vector(9 downto 0);
  signal pipe1_height, pipe1_pos            : std_logic_vector(9 downto 0);
  signal pipe2_height, pipe2_pos            : std_logic_vector(9 downto 0);
  signal game_start                         : std_logic := '0';
  signal collision                          : std_logic := '0';
  signal rng_pipe_height1, rng_pipe_height2 : std_logic_vector(9 downto 0);
  signal rng_pipe1, rng_pipe2               : std_logic;
  signal flap_btn,pause_btn                 : std_logic;
  signal level_score                        : std_logic_vector(6 downto 0) := CONV_STD_LOGIC_VECTOR(0, 7);
  signal level_complete                     : std_logic := '0';
  signal new_score								          : integer := 0;
  signal score1, score2                     : std_logic_vector(6 downto 0);
  signal pipe_gap                           : std_logic_vector(9 downto 0) := "0010010000";
  signal pipe_speed                         : std_logic_vector(9 downto 0) := "0000000010";
  
  --Screen signals
  signal screen : std_logic_vector(3 downto 0);
  
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
  inst_ScreenFSM: entity work.screen_FSM PORT MAP(
    Clk, '1',

    pb0, pb1,

    screen
  );

  r <= 
    r_game when (screen = "0001") else
    r_menu;
  g <= 
    g_game when (screen = "0001") else
    g_menu;
  b <= 
    b_game when (screen = "0001") else
    b_menu;

  --
  -- Game
  --

  -- DISPLAY GAME
  inst_Display_Game: entity work.display_controller 
  PORT MAP (
    clk_25,
    bird_height,
    pipe1_pos,pipe1_height,
    pipe2_pos,pipe2_height,
    row,column,
    pipe_gap,
    r_game,g_game,b_game
  );

  -- BIRD
  object_Bird: entity work.bird PORT MAP (
    vert_sync,
    collision,
    flap_btn,
    game_start,
    bird_height,
    game_over
  );

  flap_btn <= not(mouse_btnL) and pb2; --Why is it use AND instead of OR? Whatever.

  -- PIPE 1
  object_Pipe1: entity work.pipe
  GENERIC MAP (
    starting_pos => "1010000000"
  )
  PORT MAP (
    rng_pipe_height1,
    vert_sync,
    game_start,
    collision,
    pipe_speed,
    pipe1_height, pipe1_pos,
    rng_pipe1,
    score1
  );

  -- PIPE 2
  object_Pipe2: entity work.pipe
  GENERIC MAP (
    starting_pos => "1111000000"
  )
  PORT MAP (
    rng_pipe_height2,
    vert_sync,
    game_start,
    collision,
    pipe_speed,
    pipe2_height, pipe2_pos,
    rng_pipe2,
    score2
  );
  
  -- COLLISION
  detect_Collision: entity work.collision PORT MAP (
    clk_25,
    bird_height,
    pipe1_height, pipe1_pos,
    pipe2_height, pipe2_pos,
    pipe_gap,
    collision
  );

  -- RNG 1
  random_Number_Generator1: entity work.lfsr 
  PORT MAP (
    clk_25,
    rng_pipe1,
    rng_pipe_height1
  );
  
  -- RNG 2
  random_Number_Generator2: entity work.lfsr 
  PORT MAP (
    clk_25,
    rng_pipe2,
    rng_pipe_height2
  );

  -- SCORE CALC
  score_Display: entity work.seven_seg PORT MAP (
    score1, score2,
    level_score,
    display_tens,
    display_ones
  );
  
  --
  -- Menu
  --
  inst_Display_Menu: entity work.display_menu PORT MAP (
    clk_25,row,column,
    mouse_col,mouse_row,
    flap_btn,
    r_menu,g_menu,b_menu
  );

end architecture structure;