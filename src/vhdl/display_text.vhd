LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity display_text is 
	port(
			clk : IN STD_LOGIC;
			horiz_sync : IN STD_LOGIC;
			score : IN STD_LOGIC_VECTOR(11 downto 0);
			health_percentage : IN STD_LOGIC_VECTOR(11 downto 0);
			pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 downto 0);
			text_on, red, green, blue : OUT STD_LOGIC 
		);
end display_text;

architecture behaviour of display_text is
--CONSTANTS
CONSTANT score_start_y : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(70, 10);
CONSTANT health_start_y : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(30, 10);

CONSTANT score_rad_100_start_x : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(250, 10);
CONSTANT score_rad_10_start_x : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(300, 10);
CONSTANT score_rad_1_start_x : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(350, 10);

CONSTANT heart_start_x : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(472, 10);
CONSTANT health_rad_100_start_x : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(512, 10);
CONSTANT health_rad_10_start_x : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(552, 10);
CONSTANT health_rad_1_start_x : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(592, 10);

CONSTANT number_rom_offset : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(48,6);

--SIGNALS
SIGNAL temp_text_on, temp_text_on_1,temp_text_on_10,temp_text_on_100, 
	temp_percent_on_1, temp_percent_on_10, temp_percent_on_100, heart_on : STD_LOGIC;
SIGNAL radix_100_score, radix_10_score, radix_1_score: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL radix_100_score_add, radix_10_score_add, radix_1_score_add, radix_100_health, radix_10_health, radix_1_health : STD_LOGIC_VECTOR(5 downto 0);
component sprite_8bit
	generic (
		  	scale : STD_LOGIC_VECTOR(9 downto 0) 			
		);
	port (
			clk, reset, horiz_sync : IN STD_LOGIC;
			rom_address : IN STD_LOGIC_VECTOR(5 downto 0);
			sprite_row, sprite_column, 
			pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 downto 0);
			sprite_on: OUT STD_LOGIC
		 );
end component;
begin

radix_100_score <= score(11 downto 8);
radix_10_score <= score(7 downto 4);
radix_1_score <= score(3 downto 0);

radix_100_health <= "00" & health_percentage(11 downto 8) + number_rom_offset;
radix_10_health <= "00" & health_percentage(7 downto 4) + number_rom_offset;
radix_1_health <= "00" & health_percentage(3 downto 0) + number_rom_offset;

radix_1_score_add <= "00" & radix_1_score + number_rom_offset; 
radix_10_score_add <= "00" & radix_10_score + number_rom_offset; 
radix_100_score_add <= "00" & radix_100_score + number_rom_offset; 

radix_1_score_text : sprite_8bit 
generic map (
				CONV_STD_LOGIC_VECTOR(3,10)
			)
port map(
		clk, '0', horiz_sync,radix_1_score_add,score_start_y,score_rad_1_start_x, pixel_row, pixel_column, temp_text_on_1
		);

radix_10_score_text : sprite_8bit 
generic map (
				CONV_STD_LOGIC_VECTOR(3,10)
			)
port map(
		clk, '0', horiz_sync,radix_10_score_add,score_start_y,score_rad_10_start_x, pixel_row, pixel_column, temp_text_on_10
		);

radix_100_score_text : sprite_8bit 
generic map (
				CONV_STD_LOGIC_VECTOR(3,10)
			)
port map(
		clk, '0', horiz_sync,radix_100_score_add,score_start_y,score_rad_100_start_x, pixel_row, pixel_column, temp_text_on_100
		);

heart : sprite_8bit 
generic map (
				CONV_STD_LOGIC_VECTOR(2,10)
			)
port map(
		clk, '0', horiz_sync,CONV_STD_LOGIC_VECTOR(36,6),health_start_y,heart_start_x, pixel_row, pixel_column, heart_on

		);
radix_1_health_text : sprite_8bit 
generic map (
				CONV_STD_LOGIC_VECTOR(2,10)
			)
port map(
		clk, '0', horiz_sync,radix_1_health,health_start_y,health_rad_1_start_x, pixel_row, pixel_column, temp_percent_on_1

		);

radix_10_health_text : sprite_8bit 
generic map (
				CONV_STD_LOGIC_VECTOR(2,10)
			)
port map(
		clk, '0', horiz_sync, radix_10_health,health_start_y,health_rad_10_start_x, pixel_row, pixel_column, temp_percent_on_10
		);

radix_100_health_text : sprite_8bit 
generic map (
				CONV_STD_LOGIC_VECTOR(2,10)
			)
port map(
		clk, '0', horiz_sync, radix_100_health,health_start_y,health_rad_100_start_x, pixel_row, pixel_column, temp_percent_on_100
		);
temp_text_on <= '1' when (temp_text_on_1 = '1' or temp_text_on_10 = '1' or temp_text_on_100 = '1' or heart_on = '1' or temp_percent_on_1 = '1' or temp_percent_on_10 ='1' or temp_percent_on_100 = '1') else '0';
red <= temp_text_on;
green <= '0' when heart_on = '1' else temp_text_on;
blue <= '0' when heart_on = '1' else temp_text_on;

text_on <= temp_text_on; --when

end architecture behaviour;

