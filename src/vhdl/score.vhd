LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity score is 
	port(
			reset, score_pulse : IN STD_LOGIC;
			score_digits : OUT STD_LOGIC_VECTOR(11 downto 0)
		);
end entity;

architecture behaviour of score is
signal current_score, high_score : integer range 0 to 999 := 0;

begin

process(score_pulse, reset)
begin
	if Rising_Edge(score_pulse) then
		if reset = '1' then
			current_score <= 0;
		end if;
		current_score <= current_score + 1;
		if current_score >= high_score then
			high_score <= current_score;
		end if;
	end if;
end process;
score_digits <= CONV_STD_LOGIC_VECTOR((current_score/100) mod 10, 4)  
				& CONV_STD_LOGIC_VECTOR((current_score/10) mod 10,4) 
				& CONV_STD_LOGIC_VECTOR(current_score mod 10, 4);
end architecture behaviour;
