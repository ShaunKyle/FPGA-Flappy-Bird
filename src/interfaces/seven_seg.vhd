library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity seven_seg is
    port (
        number : in integer;
        display_tens : out std_logic_vector(6 downto 0);
        display_ones : out std_logic_vector(6 downto 0)
    );
end entity seven_seg;

architecture behaviour of seven_seg is
    signal bcd_number_ones : std_logic_vector(3 downto 0) := "0000";
    signal bcd_number_tens : std_logic_vector(3 downto 0) := "0000";
begin

    process(number)
        variable tens_v : integer := 0;
        variable ones_v : integer := 0;
    begin
		if (ones_v = 9) then
			tens_v := tens_v + 1;
			ones_v := 0;
      else
        ones_v := ones_v + 1;
		end if;

      bcd_number_ones <= CONV_STD_LOGIC_VECTOR(5, 4);
      bcd_number_tens <= CONV_STD_LOGIC_VECTOR(9, 4);
    end process;
    
    process (bcd_number_tens)
    begin
        case bcd_number_tens is
				when "0000" => display_tens <= "1000000"; -- "0"     
				when "0001" => display_tens <= "1111001"; -- "1" 
				when "0010" => display_tens <= "0100100"; -- "2" 
				when "0011" => display_tens <= "0110000"; -- "3" 
				when "0100" => display_tens <= "0011001"; -- "4" 
				when "0101" => display_tens <= "0010010"; -- "5" 
				when "0110" => display_tens <= "0000010"; -- "6" 
				when "0111" => display_tens <= "1111000"; -- "7" 
				when "1000" => display_tens <= "0000000"; -- "8"     
				when "1001" => display_tens <= "0011000"; -- "9" 
				when "1010" => display_tens <= "0001000"; -- a
				when "1011" => display_tens <= "0000011"; -- b
				when "1100" => display_tens <= "1000110"; -- C
				when "1101" => display_tens <= "0100001"; -- d
				when "1110" => display_tens <= "0000110"; -- E
				when "1111" => display_tens <= "0001110"; -- F
				when others => display_tens <= "1111111"; -- Off
        end case;
    end process;
	 
    process (bcd_number_ones)
    begin
        case bcd_number_ones is
				when "0000" => display_ones <= "1000000"; -- "0"     
				when "0001" => display_ones <= "1111001"; -- "1" 
				when "0010" => display_ones <= "0100100"; -- "2" 
				when "0011" => display_ones <= "0110000"; -- "3" 
				when "0100" => display_ones <= "0011001"; -- "4" 
				when "0101" => display_ones <= "0010010"; -- "5" 
				when "0110" => display_ones <= "0000010"; -- "6" 
				when "0111" => display_ones <= "1111000"; -- "7" 
				when "1000" => display_ones <= "0000000"; -- "8"     
				when "1001" => display_ones <= "0011000"; -- "9" 
				when "1010" => display_ones <= "0001000"; -- a
				when "1011" => display_ones <= "0000011"; -- b
				when "1100" => display_ones <= "1000110"; -- C
				when "1101" => display_ones <= "0100001"; -- d
				when "1110" => display_ones <= "0000110"; -- E
				when "1111" => display_ones <= "0001110"; -- F
				when others => display_ones <= "1111111"; -- Off
        end case;
    end process;
end architecture behaviour;
