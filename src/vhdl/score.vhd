entity score is 
	port(
			reset, score_pulse : IN STD_LOGIC;
			score_digits : OUT STD_LOGIC_VECTOR(7 downto 0)
		);
end entity;

architecture behaviour of score is
signal current_score, high_score : integer range 0 to 999 := 0;

begin

process(score_pulse, reset)
begin
	if reset = '1' then
		current_score <= 0;
	end if;
	if Rising_Edge(score_pulse) then
		current_score <= current_score + 1;
		if current_score >= high_score then
			high_score <= current_score;
		end if;
	end if;
end process;


end architecture behaviour;
