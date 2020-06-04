library IEEE;
use IEEE.std_logic_1164.all;

entity screen_FSM is 
  port(
    Clk,Reset : in std_logic;

    click_game, click_train : in std_logic;
    train_lose : in std_logic;
    game_win, game_pause, game_lose : in std_logic;

    output_state : out std_logic_vector(3 downto 0) := "0000";
    pipe_speed : out integer; --Increase difficulty every level

  );
end entity screen_FSM;


architecture behaviour of screen_FSM is 
  type t_screens is (Menu, Training, Level1, Level2, Level3, Win, Lose, Pause)
  signal state, next_state : t_screens := Menu;

begin

process(Clk) is
begin
  if rising_edge(Clk) then
    --Negative reset
    if Reset = '0' then
      state <= Menu;
    --Change state
    else
      state <= next_state;
    end if;
  end if;
end process;

-- output_state <=
--   "0000" when (state = Menu) else
--   "0001" when (state = Level1) else
--   "0010" when (state = Level2) else
--   "0011" when (state = Level3) else
--   "0100" when (state = Win) else
--   "0101" when (state = Lose) else
--   "0110" when (state = Training);

end architecture behaviour;