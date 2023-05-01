LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity cursor is
	port(
			vert_sync, mouse_click: IN STD_LOGIC;
			pixel_row, pixel_column, mouse_row, mouse_column : IN STD_LOGIC_VECTOR(9 downto 0);
			game_state : IN STD_LOGIC_VECTOR(1 downto 0);
			cursor_on, red, green, blue : OUT STD_LOGIC 
		);
end cursor;

architecture behaviour of cursor is
--CONSTANTS
CONSTANT cursor_size : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(4, 10);
--SIGNALS
SIGNAL temp_cursor_on : STD_LOGIC;
begin
temp_cursor_on <= '1' when
			(pixel_row < mouse_row + cursor_size 
			and pixel_row > mouse_row - cursor_size
			and pixel_column < mouse_column + cursor_size
			and pixel_column > mouse_column - cursor_size
			)			
			else '0';
red <= temp_cursor_on and mouse_click;
green <= temp_cursor_on and mouse_click;
blue <= temp_cursor_on or mouse_click;

cursor_on <= temp_cursor_on;

process(vert_sync)
begin
	if Rising_Edge(vert_sync) then
	end if;
end process;

end architecture behaviour;

