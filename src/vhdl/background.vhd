LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity background is 
	port(
			vert_sync: IN STD_LOGIC;
			pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 downto 0);
			background_rgb : OUT STD_LOGIC_VECTOR(11 downto 0);
			background_on  : OUT STD_LOGIC
		);
end entity;

architecture behaviour of background is
CONSTANT ground_top_y : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(420,10);

SIGNAL temp_background_on : STD_LOGIC;
begin
temp_background_on <= '1' when pixel_row <= ground_top_y else '0';
background_on <= temp_background_on;
process(pixel_row)
  begin
	if temp_background_on = '1' then
		case pixel_row is
		  when CONV_STD_LOGIC_VECTOR(0, 10)   => background_rgb <= "011101111000";
		  when CONV_STD_LOGIC_VECTOR(80, 10)  => background_rgb <= "011001101000";
		  when CONV_STD_LOGIC_VECTOR(140, 10) => background_rgb <= "010101011001";
		  when CONV_STD_LOGIC_VECTOR(190, 10) => background_rgb <= "010001001011";
		  when CONV_STD_LOGIC_VECTOR(230, 10) => background_rgb <= "001100111100";
		  when CONV_STD_LOGIC_VECTOR(265, 10) => background_rgb <= "001000101101";
		  when CONV_STD_LOGIC_VECTOR(295, 10) => background_rgb <= "000100011110";
		  when CONV_STD_LOGIC_VECTOR(320, 10) => background_rgb <= "000000001111";
		  when others => null;
		end case;
	end if;
end process;

process(vert_sync)
begin
	if Rising_Edge(vert_sync) then
	end if;
end process;
end architecture behaviour;
