library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity bird is
    port (
        vert_sync   : in std_logic;
		  reset  	  : in std_logic;
        left_btn    : in std_logic;
        game_start  : out std_logic;
        bird_height : out std_logic_vector(9 downto 0)
    );
end entity bird;

architecture behavioural of bird is
    -- keeps the bird frozen until game start
    signal game_start_s : std_logic := '1';

    -- height signals;
    signal bird_height_s : std_logic_vector(9 downto 0) := "0001111000";
    constant init_height : std_logic_vector(9 downto 0) := "0001111000";
    constant max_height : std_logic_vector(9 downto 0) := "0110101111";

    -- speed signals
    signal bird_speed   : std_logic_vector(3 downto 0) := "0000";
    signal acceleration : std_logic_vector(3 downto 0) := "0000";
    constant init_speed : std_logic_vector(3 downto 0) := "0000";
    constant max_speed  : std_logic_vector(3 downto 0) := "0011"; --0100
    constant max_acceleration : std_logic_vector(3 downto 0) := "0011";

    constant flap_speed : std_logic_vector(3 downto 0) := "1000";
    constant flap_duration : integer := 4;

    signal Q0, Q1, Q2 : std_logic := '0';
    signal stop_flap : std_logic := '0';
begin
    process(vert_sync, reset, game_start_s)
        variable loop_count : integer := 0;
    begin
        if (reset = '1') then
            bird_height_s <= init_height;
            bird_speed <= init_speed;
            acceleration <= "0001";
				game_start_s <= '0';
        else 
            if (rising_edge(vert_sync)) then
                --Start game when btn pressed
                if (left_btn = '0') then
                    game_start_s <= '1';
                end if;
				
                if (game_start_s = '1') then
                    
                    --Make height change
                    if (bird_height_s < max_height) then
                            bird_height_s <= bird_height_s + bird_speed;
                    end if; 
                    
                    if ((left_btn = '0') and (loop_count < flap_duration)) then
                        --Flap
                        if ((bird_height_s - flap_speed) > "0000000000") then
                            loop_count := loop_count + 1;
                            bird_height_s <= bird_height_s - flap_speed;
                            acceleration <= "0000";
                        end if;
                    else
                        --Reset flap once player lets go of click
                        if (left_btn = '1') then
                            loop_count := 0;
                        end if;

                        --Fall
                        if (bird_speed < max_speed) then
                            bird_speed <= bird_speed + acceleration;
                            if (acceleration < max_acceleration) then
                                acceleration <= acceleration + "0001";
                            end if;
                        end if;
                    end if;
				end if;
            end if;
        end if;
    end process;

    bird_height <= bird_height_s;
    game_start <= game_start_s;




    
    
    
end behavioural;
