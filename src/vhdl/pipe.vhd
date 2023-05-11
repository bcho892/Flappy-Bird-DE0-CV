LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_SIGNED.all;
USE IEEE.NUMERIC_STD.all;

entity pipe is
	PORT(
		vert_sync, init : IN STD_LOGIC;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		game_state: IN STD_LOGIC_VECTOR(1 downto 0);
		random_index : IN STD_LOGIC_VECTOR(3 downto 0);
		init_next, score_pulse, pipe_on, red, green, blue: OUT STD_LOGIC 
	);
end entity;

architecture behaviour of pipe is 

-- Typedef
type speed_vector is array (0 to 4) of integer;
type height_vector is array (0 to 16) of integer;

--CONSTANTS
CONSTANT preset_scroll_speeds : speed_vector := (5, 10, 12, 15, 18);
CONSTANT preset_pipe_heights : height_vector:= (81, 242, 80, 171, 213, 99, 261, 174, 36, 151, 82, 37, 142, 264, 147, 234, 131);
CONSTANT pipe_gap : Integer := 130; 
CONSTANT pipe_width : Integer := 65; 
CONSTANT pipe_spacing : Integer := 140;
CONSTANT screen_max_x : Integer := 639;
CONSTANT screen_halfway : Integer := 320;
CONSTANT score_pulse_debounce : Integer := 40;

-- SIGNALS
SIGNAL pipe_x_pos : Integer := screen_max_x + pipe_width;
SIGNAL pipe_x_motion : Integer;
SIGNAL pipe_height : Integer;
SIGNAL temp_pipe_on, top_pipe_on, bottom_pipe_on : STD_LOGIC; 
SIGNAL enable : STD_LOGIC;
SIGNAL current_index : Integer;

begin
bottom_pipe_on <= '1' when (pipe_x_pos > to_integer(unsigned(pixel_column)) 
and to_integer(unsigned(pixel_column)) > pipe_x_pos - pipe_width 
and pipe_height + pipe_gap < pixel_row) else '0'; 

top_pipe_on <= '1' when (pipe_x_pos > to_integer(unsigned(pixel_column)) 
and to_integer(unsigned(pixel_column)) > pipe_x_pos - pipe_width 
and pixel_row < pipe_height) else '0'; 

temp_pipe_on <= '1' when ( top_pipe_on = '1' or bottom_pipe_on = '1' ) else	'0';

pipe_on <= temp_pipe_on;
green <= temp_pipe_on;
current_index <= to_integer(unsigned(random_index));


move_pipe : process(vert_sync) 	
begin
		if Rising_Edge(vert_sync) then
			--allow movement of current pipe
			if game_state = "11" or game_state = "00" then 
				enable <= '0';
			elsif init = '1' then
				enable <= '1';
			end if;
			-- start the next pipe
			if pipe_x_pos < screen_max_x - pipe_spacing then
				init_next <= '1';
			else 
				init_next <= '0';
			end if;
			-- reset the pipe
			if (pipe_x_pos < 0) or game_state = "00" then
				enable <= '0';
				pipe_x_pos <= screen_max_x + pipe_width;
				pipe_x_motion <= 0;
				pipe_height <= preset_pipe_heights(current_index);
			end if;
			--move the pipe
			if enable = '1' then
				pipe_x_motion <= 2;
				pipe_x_pos <= pipe_x_pos - pipe_x_motion;
			elsif game_state /= "11" then
				pipe_height <= preset_pipe_heights(current_index);
			end if;
			--score pulse generation
			if pipe_x_pos < screen_halfway and pipe_x_pos > screen_halfway - score_pulse_debounce then
				score_pulse <= '1';
			else 
				score_pulse <= '0';
			end if;
		end if;
end process move_pipe;
end behaviour;
