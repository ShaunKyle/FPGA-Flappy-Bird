library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity collision_counter is
  port(
    clk,reset : in std_logic;
    collision : in std_logic;
    count : out integer
  );
end entity collision_counter;


architecture arc1 of collision_counter is

  signal prev_coll : std_logic;
  signal s_count : integer;
begin


  process (clk, reset, collision, prev_coll, s_count) is
  begin
    if (rising_edge(clk)) then
      if (reset = '1') then
        prev_coll <= '0';
      else
        prev_coll <= collision;

        if (collision = '1' and prev_coll = '0') then
          s_count <= s_count + 1;
        end if;
      end if;
    end if;
  end process;

end architecture arc1;