LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity cursor is
	port(
			clk,vert_sync, mouse_click: IN STD_LOGIC;
			pixel_row, pixel_column, mouse_row, mouse_column : IN STD_LOGIC_VECTOR(9 downto 0);
			game_state : IN STD_LOGIC_VECTOR(1 downto 0);
			cursor_on, red, green, blue : OUT STD_LOGIC 
		);
end cursor;

architecture behaviour of cursor is

--SIGNALS
SIGNAL temp_cursor_on : STD_LOGIC;

SIGNAL t_mouse_row, t_mouse_column : STD_LOGIC_VECTOR(9 downto 0);

component sprite 
	generic (
			scale : STD_LOGIC_VECTOR	
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

sprite_component : sprite 
generic map(
			scale => CONV_STD_LOGIC_VECTOR(2,10)
		   )
port map(
		clk, '0', vert_sync,CONV_STD_LOGIC_VECTOR(32,6),t_mouse_row,t_mouse_column, pixel_row, pixel_column, temp_cursor_on
		);

red <= temp_cursor_on and mouse_click;
green <= temp_cursor_on and mouse_click;
blue <= temp_cursor_on or mouse_click;

cursor_on <= temp_cursor_on;

process(vert_sync)
begin
	if Rising_Edge(vert_sync) then
		t_mouse_row <= mouse_row;
		t_mouse_column <= mouse_column;
	end if;
end process;

end architecture behaviour;

