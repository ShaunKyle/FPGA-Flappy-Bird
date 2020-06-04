library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity image_draw is
	generic (
		im_path : string;
		w, h : integer);
	port (
		clk : in std_logic;
		pixel_row, pixel_col, x, y : in std_logic_vector(9 downto 0);
		rgb_out	: out std_logic_vector(15 downto 0));
end entity image_draw;

architecture arch of image_draw is
	signal rgb : std_logic_vector(15 downto 0);
	signal pixel_x, pixel_y : std_logic_vector (9 downto 0);
begin
	image_comp : entity work.image_rom
		generic map (im_path, w, h)
		port map (pixel_x, pixel_y, x, y, clk, rgb);	
	process (pixel_col, pixel_row) is
	begin
		if (pixel_row = "0111100000") then
			pixel_x <= "0000000000";
			pixel_y <= "0000000000";
		elsif (pixel_col = "1001111111") then
			pixel_x <= "0000000000";
			pixel_y <= pixel_row + 1;
		else
			pixel_x <= pixel_col + 1;
			pixel_y <= pixel_row;
		end if;
	end process;
	process (pixel_row, pixel_col, x, y, rgb) is
	begin
		rgb_out <= "000000000000000";
		if (x <= (pixel_col + w/2)) and ((x + w/2) > pixel_col) then
			if ((y + h/2) > pixel_row) and (y <= (pixel_row + h/2)) then
				rgb_out <= rgb;
			end if;
		end if;
	end process;
end architecture;