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

  signal reg1,reg2 : std_logic;
  signal edge : std_logic;
  signal s_count : integer := 0;
begin

  process (clk) is
  begin
    if (rising_edge(clk)) then
      reg1 <= collision;
      reg2 <= reg1;
    end if;
  end process;

  edge <= reg1 and (not reg2);
  
  process (edge) is
  begin
    if (edge = '1') then
      s_count <= s_count + 1;
    end if;
  end process;

  count <= s_count;


  process (clk, reset) is
  begin
    if (rising_edge(clk)) then
      if (reset = '1') then
        s_count <= 0;
      end if;
    end if;
  end process;

end architecture arc1;