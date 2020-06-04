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
    display_ones  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    seven_seg2 : out std_logic_vector(6 downto 0);
    seven_seg3 : out std_logic_vector(6 downto 0)
	);
END FLAPPY_GAME;


architecture structure of FLAPPY_GAME is
  --PLL
  signal clk_25 : std_logic;

  --VGA
  signal r,g,b : std_logic_vector(3 downto 0);
  signal r_menu,g_menu,b_menu : std_logic_vector(3 downto 0);
  signal r_game,g_game,b_game : std_logic_vector(3 downto 0);
  signal r_win,g_win,b_win : std_logic_vector(3 downto 0);
  signal row,column : std_logic_vector(9 downto 0);
  signal vert_sync, horiz_sync : std_logic;

  --Mouse
  signal mouse_btnL, mouse_btnR : std_logic;
  signal mouse_row, mouse_col : std_logic_vector(9 downto 0);

  --Seven seg
  --signal in_seg0,in_seg1,in_seg2,in_seg3 : std_logic_vector(3 downto 0);


  --Game signals
  signal game_over, game_over_i, game_win   : std_logic := '0';
  signal bird_height 				                : std_logic_vector(9 downto 0);
  signal pipe1_height, pipe1_pos            : std_logic_vector(9 downto 0);
  signal pipe2_height, pipe2_pos            : std_logic_vector(9 downto 0);
  signal game_start                         : std_logic := '0';
  signal collision                          : std_logic := '0';
  signal rng_pipe_height1, rng_pipe_height2 : std_logic_vector(9 downto 0);
  signal rng_pipe1, rng_pipe2               : std_logic;
  signal flap_btn,pause_btn                 : std_logic;
  signal level_score                        : std_logic_vector(6 downto 0) := CONV_STD_LOGIC_VECTOR(0, 7);
  signal level_complete                     : std_logic;
  signal score								              : integer := 0;
  signal score1, score2                     : std_logic_vector(6 downto 0) := "0000000";
  signal pipe_gap                           : std_logic_vector(9 downto 0) := "0010010000";
  signal pipe_speed                         : std_logic_vector(9 downto 0) := "0000000010";
  signal is_train_mode : std_logic;

  signal count : integer;

  --Screen signals
  signal screen : std_logic_vector(1 downto 0) := "00";
  signal pause : std_logic;
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
    sw(0),sw(1),
    --game_win,
    score,
    screen,
    is_train_mode
  );

  LEDG <= sw;

  r <= 
    r_win when (screen = "11") else
    r_game when (screen = "10") else
    r_game when (screen = "01") else
    r_menu;
  g <= 
    g_win when (screen = "11") else
    g_game when (screen = "10") else
    g_game when (screen = "01") else
    g_menu;
  b <= 
    b_win when (screen = "11") else
    b_game when (screen = "10") else
    b_game when (screen = "01") else
    b_menu;


  pause <= '0' when (sw(9) /= '1') else '1';

  --
  -- Game
  --

  -- GAME FSM
  -- inst_GameFSM: entity work.game_FSM PORT MAP(
  --   clk_25,
  --   score,
  --   game_over_i,
  --   is_train_mode,
  --   game_over_i,
  --   level_complete,
  --   game_win,
  --   level_score,
  --   pipe_gap, pipe_speed
  -- );

  inst_Game_FSM_new: entity work.game_FSM_new PORT MAP(
    clk_25,
    sw(0),sw(1),
    score,
    is_train_mode,
    level_complete,
    game_win,
    level_score,
    pipe_gap,pipe_speed
  );



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
    pause,
    vert_sync,
    collision,
    level_complete,
    flap_btn,
    game_start,
    bird_height,
    game_over
  );

  flap_btn <= pb2 AND (NOT mouse_btnL);

  -- PIPE 1
  object_Pipe1: entity work.pipe
  GENERIC MAP (
    starting_pos => "1010000000"
  )
  PORT MAP (
    pause,
    rng_pipe_height1,
    vert_sync,
    game_start,
    collision or level_complete,
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
    pause,
    rng_pipe_height2,
    vert_sync,
    game_start,
    collision or level_complete,
    pipe_speed,
    pipe2_height, pipe2_pos,
    rng_pipe2,
    score2
  );

	score <= conv_integer(unsigned(score1)) + conv_integer(unsigned(score2)) + conv_integer(unsigned(level_score));
  
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
    score,
    display_tens,
    display_ones
  );

  --unused display
  unused_disp: entity work.seven_seg PORT MAP(
    0,
    seven_seg3,
    seven_seg2
  );

  -- collision_count: entity work.collision_counter PORT MAP(
  --   clk_25,'0',
  --   collision,
  --   count
  -- );
  
  --
  -- Menu
  --
  inst_Display_Menu: entity work.display_menu PORT MAP (
    clk_25,row,column,
    mouse_col,mouse_row,
    flap_btn,
    r_menu,g_menu,b_menu
  );

  --
  -- Win screen
  --
  inst_Display_Win: entity work.display_win PORT MAP (
    clk_25,row,column,
    r_win,g_win,b_win
  );



  --inst_img: entity work.image

end architecture structure;