LIBRARY IEEE;
USE iee.std_logic_1164.ALL;

-- CUSTOM STATE TYPE
TYPE state_types IS (menu, normal_game, game_over, training);

ENTITY FSM IS

   PORT (
      clk_in : IN STD_LOGIC;
      state_in : IN STD_LOGIC_VECTOR(1 TO 0); -- 4 different states possible so input is 
      state_out : OUT state_types; -- Output of FSM is game state (menu, NORMAL GAME, GAME OVER, training)

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

   output_decode : PROCESS (state)

   BEGIN
      CASE (state) IS
         WHEN menu =>
            IF (state_in = normal_game) THEN
               next_state <= normal_game;
            ELSIF (state_in = training) THEN
               next_state <= training;
            END IF;
         WHEN normal_game =>
            IF (state_in = game_over) THEN
               next_state <= game_over;
            END IF;
         WHEN game_over =>
            IF (state_in = menu) THEN
               next_state <= menu;
            ELSIF (state_in <= training) THEN
               next_state <= training;
            END IF;
         WHEN training =>
            IF (state_in <= menu) THEN
               next_state <= menu;
            END IF;
      END CASE;
   END PROCESS output_decode;

END ARCHITECTURE Moore;