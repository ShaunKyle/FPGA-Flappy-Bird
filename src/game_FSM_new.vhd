library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity game_FSM_new is
  port (
      clk_25               : in  std_logic;
      sw0,sw1              : in  std_logic;
      score                : in  integer;
      training             : in  std_logic;  
      level_complete       : out std_logic;
      game_win             : out std_logic;
      level_score          : out std_logic_vector(6 downto 0);
      pipe_gap, pipe_speed : out std_logic_vector(9 downto 0)
  );
end entity game_FSM_new;


architecture beehiviour of game_FSM_new is
  type t_state is (Idle, L1, L2, L3, Win, Train);
  signal state : t_state := Idle;

begin

  --Moore state machine
  process(Clk_25,score) is
  begin
    if rising_edge(Clk_25) then
      case state is
        when Idle =>
          game_win <= '0';
          level_complete <= '0';
          if (sw0 = '1') then
            state <= L1;
          elsif (sw1 = '1') then
            state <= Train;
          end if;

        when Train =>
          if (sw1 = '0') then
            state <= Idle;
          end if;

        when L1 =>
          level_complete <= '0';
          if (score = 3) then
            state <= L2;
            level_complete <= '1';
          elsif (sw0 = '0') then
            state <= Idle;
          end if;

        when L2 =>
          level_complete <= '0';
          if (score = 13) then
            state <= L3;
            level_complete <= '1';
          elsif (sw0 = '0') then
            state <= Idle;
          end if;

        when L3 =>
          level_complete <= '0';
          if (score = 23) then
            state <= Win;
            level_complete <= '1';
          elsif (sw0 = '0') then
            state <= Idle;
          end if;

        when Win =>
          game_win <= '1';
          level_complete <= '0';
          if (sw0 = '0') then
            state <= Idle;
          end if;
      end case;
    end if;
  end process;


  --Set game control signals
  process (state)
  begin
    case state is
        when L1|Train =>
            pipe_gap    <= conv_std_logic_vector(144,10);
            pipe_speed  <= conv_std_logic_vector(2,10);
            level_score <= conv_std_logic_vector(0,7);
        when L2 =>
            pipe_gap    <= conv_std_logic_vector(110,10);
            pipe_speed  <= conv_std_logic_vector(2,10);
            level_score <= conv_std_logic_vector(10,7);
        when L3 =>
            pipe_gap    <= conv_std_logic_vector(87,10);
            pipe_speed  <= conv_std_logic_vector(4,10);
            level_score <= conv_std_logic_vector(20,7);
        when others =>
            null;
      end case;
    end process;

end architecture beehiviour;