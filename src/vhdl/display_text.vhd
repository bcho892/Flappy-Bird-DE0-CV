LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity display_text is 
	port(
			clk : IN STD_LOGIC;
			score : IN STD_LOGIC_VECTOR(7 downto 0);
			pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 downto 0);
			text_on, red, green, blue : OUT STD_LOGIC 
		);
end display_text;

architecture behaviour of display_text is
--CONSTANTS
CONSTANT score_start_y : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(100, 10);
CONSTANT score_start_x : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(200, 10);
CONSTANT score_end_y : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(150, 10);
CONSTANT score_end_x : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(250, 10);

--SIGNALS
SIGNAL temp_text_on : STD_LOGIC;
SIGNAL text_corresponding_address : STD_LOGIC_VECTOR(5 downto 0) := CONV_STD_LOGIC_VECTOR(20, 6);
SIGNAL current_row, current_col : STD_LOGIC_VECTOR(2 downto 0) := CONV_STD_LOGIC_VECTOR(6,3);

component char_rom 
PORT 
(
	character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
	font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
	clock				: 	IN STD_LOGIC ;
	rom_mux_output		:	OUT STD_LOGIC
);
end component;
begin
char_rom_component : char_rom
port map(
			character_address => text_corresponding_address,
			font_row => current_row,
			font_col => current_col,
			clock => clk,
			rom_mux_output => temp_text_on 
	 	);
current_row <= pixel_row(4 downto 2) - score_start_y(4 downto 2);
current_col <= pixel_column(4 downto 2) - score_start_x(4 downto 2);
red <= temp_text_on;  
text_on <= temp_text_on when
(pixel_row <= score_end_y and score_start_y <= pixel_row) 
			  and (pixel_column <= score_end_x and score_start_x <= pixel_column) else '0';

end architecture behaviour;

