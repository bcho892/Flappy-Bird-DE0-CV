LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

entity sprite is 
	port (
			clk, reset, horiz_sync : IN STD_LOGIC;
			sprite_row, sprite_column, 
			pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 downto 0);
			sprite_on: OUT STD_LOGIC
		 );
end sprite;

architecture behaviour of sprite is
TYPE state_type is (IDLE, REG_POS, ACTIVE, WAIT_POS, SPR_LINE, WAIT_DATA);
CONSTANT SCREEN_MAX_X : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(639,10);
CONSTANT SPRITE_HEIGHT, SPRITE_WIDTH : STD_LOGIC_VECTOR(2 downto 0) := CONV_STD_LOGIC_VECTOR(8,3);

SIGNAL state : state_type := IDLE;
SIGNAL sprite_active, sprite_begin, sprite_end, line_end : STD_LOGIC;
SIGNAL bmap_column, bmap_row : STD_LOGIC_VECTOR(2 downto 0);
SIGNAL t_sprite_row, t_sprite_column : STD_LOGIC_VECTOR(9 downto 0);

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
			character_address => CONV_STD_LOGIC_VECTOR(48,6),
			font_row => bmap_row,
			font_col => bmap_column,
			clock => clk,
			rom_mux_output => sprite_on  
	 	);

sprite_active <= '1' when pixel_row - t_sprite_row >= CONV_STD_LOGIC_VECTOR(0,10) and pixel_row - t_sprite_row < SPRITE_HEIGHT else '0';
sprite_begin <= '1' when pixel_column >= t_sprite_row else '0';
sprite_end <= '1' when bmap_column = SPRITE_WIDTH - CONV_STD_LOGIC_VECTOR(1,3) else '0';
line_end <= '1' when pixel_column = SCREEN_MAX_X else '0';


process (clk)
begin
	if reset = '1' then
		state <= IDLE;

	end if;
	if Rising_Edge(clk) then
		if horiz_sync = '1' then
			state <= REG_POS;
		else 
			case state is
				when REG_POS => 
					state <= ACTIVE;
					t_sprite_row <= sprite_row;
					t_sprite_column <= sprite_column;
				when ACTIVE => 
					if sprite_active = '1' then
						state <= WAIT_POS;
					else 
						state <= IDLE;
					end if;
				when WAIT_POS =>
					if sprite_begin = '1' then
						state <= SPR_LINE;
						bmap_column <= CONV_STD_LOGIC_VECTOR(0,3);
						bmap_row <= CONV_STD_LOGIC_VECTOR(0,3);
					end if;
				when SPR_LINE =>
					if sprite_end = '1' or line_end = '1' then 
						state <= WAIT_DATA;
					end if;
					bmap_column <= bmap_column + 1;
				when WAIT_DATA =>
					state <= IDLE;
					sprite_on <= '0';
				when others =>
					state <= IDLE;
			end case;
		end if;
	end if;
end process;

end architecture behaviour;

