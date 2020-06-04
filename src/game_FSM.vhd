library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity game_FSM is
    port (
        clk_25 : in std_logic;
        collision : in std_logic;
        level_complete : in std_logic;
        game_over : in std_logic;
        next_level : out std_logic;
        lives : out std_logic_vector(1 downto 0);
    );