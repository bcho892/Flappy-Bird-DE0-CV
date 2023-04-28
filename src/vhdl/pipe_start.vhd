LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity pipe_start is
	port(
			clk, reset : IN STD_LOGIC;
			pulse : OUT STD_LOGIC
		);
end entity pipe_start;

architecture behaviour of pipe_start is 
SIGNAL state : STD_LOGIC := '0';
begin
process (clk, reset)
begin
	if Rising_Edge(clk) then
		if reset = '1' then 
			state <= '0';
		end if;
		case state is
			when '0' => 
				pulse <= '1';
				state <= '1';
			when '1'  =>
				pulse <= '0';
		end case;
	end if;
end process;
end architecture;
