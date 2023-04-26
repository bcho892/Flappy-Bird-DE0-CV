entity pipe is
	PORT(
		vert_sync, init : IN STD_LOGIC;
        pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		game_state: IN STD_LOGIC_VECTOR(2 downto 0);
		game_level : IN STD_LOGIC_VECTOR(2 downto 0);
		random_index : IN STD_LOGIC_VECTOR(3 downto 0);
		init_next, red, green, blue : OUT STD_LOGIC
	)
end entity;

architecture behaviour of pipe is 
-- SIGNALS
SIGNAL left_offset : STD_LOGIC_VECTOR(10 downto 0)
SIGNAL pipe_x_motion : STD_LOGIC_VECTOR(10 downto 0);
SIGNAL pipe_on : STD_LOGIC; 
SIGNAL enable : STD_LOGIC;

-- Typedef
type unsigned_speed_vector is array (0 to 4) of unsigned;
type unsigned_height_vector is array (0 to 14) of unsigned;

--CONSTANTS
CONSTANT preset_scroll_speeds : unsigned_vector := (5, 10, 12, 15, 18);
CONSTANT preset_pipe_heights : unsigned_height_vector;
CONSTANT pipe_gap : STD_LOGIC_VECTOR();
CONSTANT pipe_width : STD_LOGIC_VECTOR();
CONSTANT screen_max_x : STD_LOGIC_VECTOR(10 downto 0) := CONV_STD_LOGIC_VECTOR(639, 10);

begin
move_pipe : process(vert_sync) 	
begin
	if Rising_Edge(vert_sync) then
		-- off the screen
		if left_offset < conv_std_logic_vector(0, 10) - pipe_width then 
			left_offset <= CONV_STD_LOGIC_VECTOR(0, 10);
			pipe_x_motion <= CONV_STD_LOGIC_VECTOR(0,10);
		elsif init = '1'
			pipe_x_motion <= CONV_STD_LOGIC_VECTOR(preset_scroll_speeds(1), 10);
		end if;
		-- when to start moving next pipe
		if left_offset < left_offset - pipe_width then
			init_next <= '1';
		else 
			init_next <= '0';
		end if;
		left_offset <= left_offset - pipe_x_motion;
	end if;
end process move_pipe;
end behaviour;
