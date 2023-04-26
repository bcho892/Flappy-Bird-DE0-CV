LIBRARY IEEE;
USE iee.std_logic_1164.ALL;

-- CUSTOM STATE TYPE
TYPE state_types IS (MENU, NORMAL_GAME, GAME_OVER, TRAINING);

ENTITY FSM IS

   PORT (
      clk_in : IN STD_LOGIC;
      next_state_in : IN STD_LOGIC_VECTOR(1 TO 0); -- 4 different states possible so input is 
      state_out : OUT INTEGER; -- Output of FSM is game state (MENU, NORMAL GAME, GAME OVER, TRAINING)

   );
END ENTITY FSM;

ARCHITECTURE Moore OF FSM IS
   SIGNAL state, next_state : state_types;

BEGIN

   -- Process used to update the next state of game every clock cycle
   state_sync : PROCESS (clk_in)
   BEGIN
      IF rising_edge(clk_in) THEN
         IF (reset = '1') THEN -- When reset is pressed, reset back to GAME START state 
            state_out <= S0;
         ELSE
            state_out <= next_state;
         END IF;
      END IF;

   END PROCESS state_sync;

   state_decode : PROCESS (clk_in, next_state_in)

      output : PROCESS (state)
      BEGIN
         CASE (state) IS
            WHEN MENU =>

         END CASE;
      END PROCESS output;

   END ARCHITECTURE Moore;