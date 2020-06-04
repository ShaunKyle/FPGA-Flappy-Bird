-- code adapted from https://www.nandland.com/vhdl/modules/lfsr-linear-feedback-shift-register.html
library ieee;
use ieee.std_logic_1164.all;
 
entity LFSR is
  port (
    clk_25      : in std_logic;
    enable	    : in std_logic;   
    rng_number  : out std_logic_vector(9 downto 0)
   );
end entity LFSR;
 
architecture Behavioural of LFSR is
  signal r_LFSR : std_logic_vector(9 downto 1) := (others => '0');
  signal XNOR_val : std_logic;
begin
  process (clk_25)
  begin
    if rising_edge(clk_25) then
      if enable = '1' then
          r_LFSR <= r_LFSR(r_LFSR'left-1 downto 1) & XNOR_val;
      end if;
    end if;
  end process; 
 
  XNOR_val <= r_LFSR(9) xnor r_LFSR(5);
  rng_number <= '0' & r_LFSR(r_LFSR'left downto 1); 
  
end architecture Behavioural;