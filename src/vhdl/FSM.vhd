LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;


ENTITY FSM IS

   PORT (
      clk_in, reset, mouse_click : IN STD_LOGIC;
   		collision : IN STD_LOGIC_VECTOR(2 downto 0);
      state_out : OUT STD_LOGIC_VECTOR(1 downto 0) := "00"-- Output of FSM is game state (menu, NORMAL GAME, GAME OVER, training)
   );
END ENTITY FSM;

ARCHITECTURE Moore OF FSM IS
	CONSTANT debounce_time : Integer := 4000000;
	CONSTANT pipe_collision_debounce_time :Integer := 24000000;
	CONSTANT max_collisions : INTEGER range 0 to 1000000:= 30000;
   -- define states
   type state_type is (game_start, normal_mode, training_mode, game_over);
   SIGNAL current_state, next_state : state_type := game_start;
   SIGNAL count : Integer range 0 to 25000000;
   SIGNAL collision_count : Integer range 0 to 1000000 := 0;

BEGIN
   -- process to describe state transitions
   transition : process (clk_in, current_state, collision, mouse_click)
   BEGIN
	   if Rising_Edge(clk_in) then
		  CASE (current_state) IS
			 WHEN game_start =>
				 state_out <= "00";
				if count >= debounce_time and mouse_click = '1' then
				   next_state <= normal_mode;
			   elsif count >= debounce_time then
				   count <= debounce_time;
				else
					count <= count + 1;
				   next_state <= game_start; 
				end if;
			 WHEN normal_mode =>
				 state_out <= "01";
				 case collision is 
					 when "000" => next_state <= normal_mode;
					 when "001" => 
						if (collision_count > max_collisions) then
						  next_state <= game_over;
						  count <= 0;
						  collision_count <= 0;
						else
							collision_count <= collision_count + 1;
						end if;

					 when "010" => 
						 next_state <= game_over;
						 count <= 0;
					 when others => 
						 next_state <= normal_mode;
				end case;
			 WHEN game_over =>
				 state_out <= "11";

				if count >= debounce_time and mouse_click = '1' then
				   next_state <= game_start;
				   count <= 0;
			   elsif count >= debounce_time then
				   count <= debounce_time;
				else
					count <= count + 1;
				   next_state <= game_over; 
				end if;
			 WHEN training_mode =>
				 state_out <= "10";
				 case collision is 
					 when "000" => next_state <= normal_mode;
					 when "001" => 
						 next_state <= game_over;
						 count <= 0;

					 when "010" => 
						 next_state <= game_over;
						 count <= 0;
					 when others => next_state <= normal_mode;
				end case;
		  END CASE;
		current_state <= next_state;
		end if;
	  
   end process;

END ARCHITECTURE Moore;
