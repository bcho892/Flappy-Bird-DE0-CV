entity pipe is
	PORT(
		init, reset : IN STD_LOGIC;
		game_state: IN STD_LOGIC_VECTOR(2 downto 0);
		game_level : IN STD_LOGIC_VECTOR(2 downto 0);
		random_index : IN STD_LOGIC_VECTOR(3 downto 0);
		init_next : OUT STD_LOGIC
	)
end entity;

architecture behaviour of pipe is 
-- SIGNALS
SIGNAL pipe_x_motion : STD_LOGIC_VECTOR(10 downto 0);
SIGNAL pipe_on : STD_LOGIC; 

-- Typedef
type unsigned_speed_vector is array (0 to 4) of unsigned;
type unsigned_height_vector is array (0 to 14) of unsigned;

--CONSTANTS
CONSTANT preset_scroll_speeds : unsigned_vector := (5, 10, 12, 15, 18);
CONSTANT preset_pipe_heights : unsigned_height_vector;
CONSTANT pipe_gap : STD_LOGIC_VECTOR();
CONSTANT pipe_width : STD_LOGIC_VECTOR();

begin
end behaviour;
