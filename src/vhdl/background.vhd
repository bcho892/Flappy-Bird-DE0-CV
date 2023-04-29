LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity background is 
	port(
			vert_sync: IN STD_LOGIC;
			pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 downto 0);
			background_on, red, green, blue : OUT STD_LOGIC
		);
end entity;

architecture behaviour of background is
CONSTANT ground_top_y : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(420,10);

SIGNAL temp_background_on : STD_LOGIC;
begin
temp_background_on <= '1' when pixel_row <= ground_top_y else '0';
background_on <= temp_background_on;
green <= '1';
blue <= '1';
process(vert_sync)
begin
	if Rising_Edge(vert_sync) then
	end if;
end process;
end architecture behaviour;
