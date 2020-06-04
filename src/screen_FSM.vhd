library IEEE;
use IEEE.std_logic_1164.all;

entity screen_FSM is 
  port(
    Clk,Reset : in std_logic;
    pb0,pb1 : in std_logic;
    -- click_game, click_train : in std_logic;
    -- train_lose : in std_logic;
    -- game_win, game_pause, game_lose : in std_logic;

    output_state : out std_logic_vector(3 downto 0) := "0000"
    -- pipe_speed : out integer; --Increase difficulty every level

  );
end entity screen_FSM;


architecture behaviour of screen_FSM is 
  type t_screens is (Menu, Training, Level1, Level2, Level3, Win, Lose, Pause);
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
      case state is
        when Menu =>
          output_state <= "0000";

          if pb0 = '0' then
            state <= Level1;
          end if;

          if pb1 = '0' then
            state <= Training;
          end if;
        
        when Level1 =>
          output_state <= "0001";

          if pb1 = '0' then
            state <= Pause;
          end if;
        when Level2 =>
          output_state <= "0010";
        when Level3 =>
          output_state <= "0011";
        when Win =>
          output_state <= "0100";
        when Lose =>
          output_state <= "0101";  
        when Training =>
          output_state <= "0110";
        when Pause =>
          output_state <= "0111";


      end case;
    end if;
  end if;
end process;


end architecture behaviour;