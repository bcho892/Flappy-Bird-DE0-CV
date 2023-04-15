Entity FLAPPY_BIRD is
	Port (
		clk, pb1, pb2 : IN STD_LOGIC;
		red_out, green_out, blue_out, horiz_sync_out, vert_sync_out: OUT STD_LOGIC,
	)
end Entity;

ARCHITECTURE structural of FLAPPY_BIRD IS
	-- Clock Divider
	COMPONENT clock_divider IS
	port(
      clk_in : in std_logic;
      clk_out : out std_logic
    );
	END COMPONENT clock_divider;		
	-- Bouncy Ball
	COMPONENT bouncy_ball IS
	PORT
		( pb1, pb2, clk, vert_sync	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);
	END COMPONENT bouncy_ball;	
	-- VGA Sync
	COMPONENT vga_sync IS
	PORT(	clock_25Mhz, red, green, blue		: IN	STD_LOGIC;
			red_out, green_out, blue_out, horiz_sync_out, vert_sync_out	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
	END COMPONENT vga_sync;
	-- Internal Signals
	SIGNAL internal_clk : STD_LOGIC;
	SIGNAL red, green, blue : STD_LOGIC;
	SIGNAL vert_sync: STD_LOGIC;
	SIGNAL pixel_row, pixel_column : STD_LOGIC_VECTOR(9 DOWNTO 0);
BEGIN
	clock_divider: clock_divider PORT MAP(clk, internal_clk);
	bouncy_ball: bouncy_ball PORT MAP(pb1, pb2, internal_clk, vert_sync,  pixel_row, pixel_column,
									 red, green, blue);
	vga_sync: vga_sync PORT MAP(internal_clk, red, green, blue,
							   red_out, green_out, blue_out, horiz_sync_out, vert_sync,
								pixel_row, pixel_column
						   );
	vert_sync_out <= vert_sync;	
END ARCHITECTURE;
