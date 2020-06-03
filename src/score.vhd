library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity score is
	port (
		reset : in  std_logic;
		--level_score	  : in  integer;
		current_score : in  integer;
		enable		  : in  std_logic;
		new_score	  : out integer
	);
end entity score;

architecture behavioural of score is
	signal score_s	 : integer := 0;
begin
	process
	begin
		if (reset = '1') then
			-- score_s <= level_score;
			score_s <= 0;
		elsif (enable = '1') then
			score_s <= current_score + 1;
		else
			score_s <= current_score;
		end if;
		wait until enable='1';
	end process;
end behavioural;

	