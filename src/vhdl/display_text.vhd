LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity display_text is 
	port(
			clk : IN STD_LOGIC;
			horiz_sync : IN STD_LOGIC;
			score : IN STD_LOGIC_VECTOR(11 downto 0);
			pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 downto 0);
			text_on, red, green, blue : OUT STD_LOGIC 
		);
end display_text;

architecture behaviour of display_text is
--CONSTANTS
CONSTANT score_start_y : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(70, 10);

CONSTANT score_rad_10_start_x : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(300, 10);

CONSTANT number_rom_offset : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(48,6);

--SIGNALS
SIGNAL temp_text_on : STD_LOGIC;
SIGNAL score_text_corresponding_address : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(20, 6);
SIGNAL current_row, current_col : STD_LOGIC_VECTOR(2 downto 0) := CONV_STD_LOGIC_VECTOR(6,3);
component sprite 
	port (
			clk, reset, horiz_sync : IN STD_LOGIC;
			rom_address : IN STD_LOGIC_VECTOR(5 downto 0);
			sprite_row, sprite_column, 
			pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 downto 0);
			sprite_on: OUT STD_LOGIC
		 );
end component;
begin

sprite_component : sprite 
port map(
		clk, '0', horiz_sync,CONV_STD_LOGIC_VECTOR(22,6),score_start_y,score_rad_10_start_x, pixel_row, pixel_column, temp_text_on
		);

red <= temp_text_on;  
--green <= temp_text_on;
--blue <= temp_text_on;
text_on <= temp_text_on; --when
--(pixel_row <= score_end_y and score_start_y <= pixel_row) 
--			  and (pixel_column <= score_rad_1_end_x and score_rad_100_start_x <= pixel_column) else '0';

end architecture behaviour;

