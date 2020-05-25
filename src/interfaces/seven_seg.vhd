library IEEE;
use IEEE.std_logic_1164.all;
--Todo: convert to using integer input?
entity seven_seg is
  port(
    Hex_in  : in std_logic_vector(3 downto 0);
    Disp_out  : out std_logic_vector(6 downto 0)
  );
end entity seven_seg;


architecture behavioural of seven_seg is

begin
  -- with Hex_in select Disp_out <=
  --   "11000000" when "0000",
  --   "11111001" when "0001",
  --   "10100100" when "0010",
  --   "10110000" when "0011",
  --   "10011001" when "0100",
  --   "10010010" when "0101",
  --   "10000010" when "0110",
  --   "11111000" when "0111",
  --   "10000000" when "1000",
  --   "10011000" when "1001",

  --   "10001000" when "1010",
  --   "10000011" when "1011", --lowercase b
  --   "11000110" when "1100",
  --   "10100001" when "1101", --lowercase d
  --   "10000110" when "1110",
  --   "10001110" when "1111",

  --   "11111111" when others;

  --Without decimal point
  with Hex_in select Disp_out <=
    "1000000" when "0000",
    "1111001" when "0001",
    "0100100" when "0010",
    "0110000" when "0011",
    "0011001" when "0100",
    "0010010" when "0101",
    "0000010" when "0110",
    "1111000" when "0111",
    "0000000" when "1000",
    "0011000" when "1001",

    "0001000" when "1010",
    "0000011" when "1011", --lowercase b
    "1000110" when "1100",
    "0100001" when "1101", --lowercase d
    "0000110" when "1110",
    "0001110" when "1111",

    "1111111" when others;

    --See pg 26 DE0 user manual

end architecture behavioural;