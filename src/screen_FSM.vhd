library IEEE;
use IEEE.std_logic_1164.all;

entity screen_FSM is 
  port(
    Clk,Reset : in std_logic;
    sw0,sw1 : in std_logic;
    --game_win : in std_logic;
    score : in integer;

    output_state : out std_logic_vector(1 downto 0) := "00";
    is_train_mode : out std_logic := '0'

  );
end entity screen_FSM;


architecture behaviour of screen_FSM is 
  type t_screens is (Menu, Training, Game, Win);
  signal state : t_screens := Menu;

  signal s_state_out : std_logic_vector(1 downto 0);
  signal s_train_out : std_logic;
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
          s_state_out <= "00";
          s_train_out <= '0';
          if sw0 = '1' then
            state <= Game;
          elsif sw1 = '1' then
            state <= Training;
          end if;
        
        when Game =>
          s_state_out <= "01";
          if (score = 23) then
            state <= Win;
          elsif sw0 = '0' then
            state <= Menu;
          end if;
        
        when Training =>
          s_train_out <= '1';
          s_state_out <= "10";
          if sw1 = '0' then
            state <= Menu;
          end if;

        when Win =>
          s_state_out <= "11";
          --Exit to main menu
          if sw0 = '0' then
            state <= Menu;
          end if;
        
      end case;
    end if;
  end if;
end process;

output_state <= s_state_out;
is_train_mode <= s_train_out;


end architecture behaviour;