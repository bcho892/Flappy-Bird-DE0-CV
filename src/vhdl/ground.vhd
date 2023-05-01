LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity ground is
	port(
			vga_sync : IN STD_LOGIC;
			pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 downto 0);
			ground_on, red, green, blue: OUT STD_LOGIC
		);
end entity ground;

architecture behaviour of ground is
--CONSTANTS
CONSTANT ground_top_y : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(420,10);
--SIGNALS
SIGNAL temp_ground_on : STD_LOGIC;
begin
temp_ground_on <= '1' when (ground_top_y <= pixel_row) else '0'; 
red <= temp_ground_on;
ground_on <= temp_ground_on;
end architecture behaviour; 
