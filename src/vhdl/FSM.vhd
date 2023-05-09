LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;


ENTITY FSM IS

   PORT (
      clk_in, reset, collision, mouse_click : IN STD_LOGIC;
      state_out : OUT STD_LOGIC_VECTOR(1 downto 0) := "00"-- Output of FSM is game state (menu, NORMAL GAME, GAME OVER, training)
   );
END ENTITY FSM;

ARCHITECTURE Moore OF FSM IS
   -- define states
   type state_type is (game_start, normal_mode, training_mode, game_over);
   SIGNAL current_state, next_state : state_type := game_start;

BEGIN
   -- Process used to update the next state of game every clock cycle
   state_sync : PROCESS (clk_in)
   BEGIN
	if Rising_Edge(clk_in) then
		current_state <= next_state;
    end if;
   END PROCESS state_sync;

   -- process to describe state transitions
   transition : process (current_state, collision, mouse_click)
   BEGIN
      CASE (current_state) IS
         WHEN game_start =>
			 state_out <= "00";
            if mouse_click = '1' then
               next_state <= normal_mode;
            -- training mode to be implemented later. currently, launches start screen and click to start normal operation
            else
               next_state <= game_start;
            end if;
         WHEN normal_mode =>
			 state_out <= "01";
            if collision = '1' then
               next_state <= game_over;
            else
               next_state <= normal_mode;
            end if;
         WHEN game_over =>
			 state_out <= "11";
            if(mouse_click = '1') then
               next_state <= game_over;
            else
               next_state <= game_over; 
            end if;
         WHEN training_mode =>
			 state_out <= "10";
            if collision = '1' then
               next_state <= game_over;
            else
               next_state <= training_mode;
            end if;
      END CASE;
	  
   end process;

END ARCHITECTURE Moore;
