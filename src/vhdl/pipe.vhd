entity pipe is
	PORT(
		init, reset : IN STD_LOGIC;
		game_level : IN STD_LOGIC_VECTOR(2 downto 0);
		random_index : IN STD_LOGIC_VECTOR(3 downto 0);
		init_next : OUT STD_LOGIC
	)
end entity;

architecture behaviour of pipe is 

end behaviour;
