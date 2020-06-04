library IEEE;
use IEEE.std_logic_1164.all;

entity screen_FSM is 
  port(
    Clk,Reset : in std_logic;
    pb0,pb1 : in std_logic;
    game_win : in std_logic;
    -- click_game, click_train : in std_logic;
    -- train_lose : in std_logic;
    -- game_win, game_pause, game_lose : in std_logic;

    output_state : out std_logic_vector(1 downto 0) := "00"
    --is_train_mode : out std_logic := '0';

  );
end entity screen_FSM;


architecture behaviour of screen_FSM is 
  type t_screens is (Menu, Training, Game, Win);
  signal state : t_screens := Menu;
  signal train_out : std_logic;
begin

process(Clk,game_win, pb0, pb1) is
begin
  if rising_edge(Clk) then
    --Negative reset
    if Reset = '0' then
      state <= Menu;
    --Change state
    else
      case state is
        when Menu =>
          output_state <= "00";

          if pb0 = '0' then
            state <= Game;
          end if;

          if pb1 = '0' then 
            state <= Training;
          end if;
        
        when Game =>
          output_state <= "01";

          if (game_win = '1') then
            state <= Menu;
          end if;

          --Rage quit btn
          if pb1 = '0' then
            state <= Menu;
          end if;
        
        when Training =>
          output_state <= "10";

          --Rage quit btn
          if pb1 = '0' then
            state <= Menu;
          end if;

        when Win =>
          output_state <= "11";
        
      end case;
    end if;
  end if;
end process;


end architecture behaviour;