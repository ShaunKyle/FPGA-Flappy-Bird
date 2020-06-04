library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity game_FSM is
    port (
        clk_25               : in  std_logic;
        collision            : in  std_logic;
        score                : in  integer;
        level_complete       : in  std_logic;
        game_over_i          : in  std_logic;
        sw                   : in  std_logic;
        game_over            : out std_logic;   
        level_complete_o     : out std_logic;
        game_win             : out std_logic;
        main_menu            : out std_logic;
        level_score          : out std_logic_vector(6 downto 0);
        lives                : out std_logic_vector(1 downto 0);
        pipe_gap, pipe_speed : out std_logic_vector(9 downto 0)
    );
end entity game_FSM;

architecture behavioural of game_FSM is
    -- S0 level 1, S1 level 2, S2, level 3, S3 game over, S4 game win
    type state_type is (S0, S1, S2, S3, S4, S5);

    -- architecture signals
    signal state   : state_type := S0;
    signal lives_s, live : std_logic_vector(1 downto 0);
    signal level_complete_s : std_logic;
begin
    process(clk_25, collision, score, game_over_i)
    begin
        if (rising_edge(clk_25)) then
            if (game_over_i = '1') then
                state <= s0;
                game_over <= not(game_over_i);
                lives_s <= "11";
            elsif (sw = '1') then
                state <= s5;
            else
                case state is
                    when s0 =>
                        level_complete_o <= '0';
                        if (score = 3) then
                            state <= s1;
                            level_complete_o <= '1';
                        elsif ((collision = '1') and (lives_s > "01")) then
                            lives_s <= lives_s - 1;
                            state <= s0;
                        elsif ((collision = '1') and (lives_s = "01")) then
                            state <= s3;
                        end if;

                    when s1 =>
                        level_complete_o <= '0';
                        if (score = 30) then
                            state <= s2;
                            level_complete_o <= '1';
                        elsif ((collision = '1') and (lives_s > "01")) then
                            lives_s <= lives_s - 1;
                            state <= s1;
                        elsif ((collision = '1') and (lives_s = "01")) then
                            state <= s3;
                        end if;

                    when s2 =>
                        level_complete_o <= '0';
                        if (score = 45) then
                            state <= s4;
                            level_complete_o <= '1';
                        elsif ((collision = '1') and (lives_s > "01")) then
                            lives_s <= lives_s - 1;
                            state <= s2;
                        elsif ((collision = '1') and (lives_s = "01")) then
                            state <= s3;
                        end if;

                    when s3 =>
                        game_over <= '1';

                    when s4 =>
                        game_win <= '1';
                        lives_s <= "11";
                    
                    when s5 =>
                        lives_s <= "01";
                        state <= s0;
                end case;
            end if;
        end if;
    end process;

    process (state)
        variable lives_v : std_logic_vector(1 downto 0);
        variable level_complete_v : std_logic;
    begin
        case state is
            when s0 =>
                pipe_gap    <= "0010010000";
                pipe_speed  <= "0000000010";
                level_score <=    "0000000";
            when s1 =>
                pipe_gap    <= "0001111000";
                pipe_speed  <= "0000000010";
                level_score <=    "0001111";
            when s2 =>
                pipe_gap    <= "0001010111";
                pipe_speed  <= "0000000011";
                level_score <=    "0011110";
            when others =>
                null;
        end case;
    end process;

    lives <= lives_s;

end behavioural;
                
