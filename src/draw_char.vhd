library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity draw_char is
  --EVen more TODO: generic for font size
  port(
    clk : in std_logic; --25MHz VGA
    char : in std_logic_vector(5 downto 0);
    x,y : in integer;  --x and y coordinates of where to draw char (this is janky, rewrite it later)
    --Note: Piazza @80, coordinates must be within 32x32 (or whatever scale factor) boxes. Explain why
    pixel_row, pixel_column : in std_logic_vector(9 downto 0); --VGA info (which row/column is currently being drawn)
    pixel_out : out std_logic
  );
end entity draw_char;

architecture arch of draw_char is
  signal font_row,font_col : std_logic_vector(2 downto 0);
  --Also jank.
begin
  CharDisp: entity work.char_rom port map(char,font_row,font_col,clk,pixel_out);
  --Note: Need to find a solution for displaying strings/multiple characters without multiple char_rom components

  process (pixel_row, pixel_column, x, y, char) is
  begin
    if (to_integer(unsigned(pixel_column)) >= x and to_integer(unsigned(pixel_column)) < (x + 16))
    and (to_integer(unsigned(pixel_row)) >= y and to_integer(unsigned(pixel_row)) < (y + 16)) then
      font_row <= pixel_row(3 downto 1);
      font_col <= pixel_column(3 downto 1);
    else
      font_row <= "000";
      font_col <= "000";
    end if;
  end process;


end architecture arch;
