LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;
USE IEEE.NUMERIC_STD;

entity pipe is
	PORT(
		vert_sync, init : IN STD_LOGIC;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		game_state: IN STD_LOGIC_VECTOR(2 downto 0);
		game_level : IN STD_LOGIC_VECTOR(2 downto 0);
		random_index : IN STD_LOGIC_VECTOR(3 downto 0);
		init_next, pipe_on, red, green, blue: OUT STD_LOGIC 
	);
end entity;

architecture behaviour of pipe is 

-- Typedef
type speed_vector is array (0 to 4) of integer;
type height_vector is array (0 to 16) of integer;

--CONSTANTS
CONSTANT preset_scroll_speeds : speed_vector := (5, 10, 12, 15, 18);
CONSTANT preset_pipe_heights : height_vector:= (58, 33, 46, 233, 243, 108, 304, 196, 286, 96, 15, 32, 216, 292, 323, 269, 144);
CONSTANT pipe_gap : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(120, 10); 
CONSTANT pipe_width : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(40,10); 
CONSTANT pipe_spacing : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(120, 10);
CONSTANT screen_max_x : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(639, 10);

-- SIGNALS
SIGNAL pipe_x_pos : STD_LOGIC_VECTOR(9 downto 0) := screen_max_x;
SIGNAL pipe_x_motion : STD_LOGIC_VECTOR(9 downto 0);
SIGNAL pipe_height : STD_LOGIC_VECTOR(9 downto 0) := CONV_STD_LOGIC_VECTOR(preset_pipe_heights(1), 10);
SIGNAL temp_pipe_on : STD_LOGIC; 
SIGNAL enable : STD_LOGIC;
SIGNAL current_index : Integer;

begin
temp_pipe_on <= '1' when ( 
(pipe_x_pos >= pixel_column and pixel_column >= pipe_x_pos - pipe_width) and
(pipe_height + pipe_gap <= pixel_row or (pipe_x_pos >= pixel_column and pixel_column >= pipe_x_pos - pipe_width and pixel_row <= pipe_height))
	   ) else	'0';
green <= temp_pipe_on;
pipe_on <= temp_pipe_on;
current_index <= numeric_std.to_integer(numeric_std.unsigned(random_index));

move_pipe : process(vert_sync) 	
begin
	if Rising_Edge(vert_sync) then
		if init = '1' then
			enable <= '1';
		end if;

		if '0' & pipe_x_pos < '0' & screen_max_x - pipe_spacing then
			init_next <= '1';
		else 
			init_next <= '0';
		end if;

		if '0' & pipe_x_pos > '0' & screen_max_x + pipe_width then
			enable <= '0';
			pipe_x_pos <= screen_max_x + pipe_width;
			pipe_x_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			pipe_height <= CONV_STD_LOGIC_VECTOR(preset_pipe_heights(current_index), 10);
		end if;
		if enable = '1' then
			pipe_x_motion <= CONV_STD_LOGIC_VECTOR(2,10);
			pipe_x_pos <= pipe_x_pos - pipe_x_motion;
		end if;

	end if;
end process move_pipe;
end behaviour;
