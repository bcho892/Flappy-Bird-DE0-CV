LIBRARY IEEE;
USE iee.std_logic_1164.ALL;

-- CUSTOM STATE TYPE
TYPE state_type IS (S0, S1);

ENTITY FSM IS

   PORT (
      clk : IN STD_LOGIC;
      swtich : IN STD_LOGIC;

   );
END ENTITY FSM;

ARCHITECTURE Moore OF FSM IS
   SIGNAL state, next_state : state_type;

BEGIN

   -- Process used to update the next state of game every clock cycle
   state_sync : PROCESS (clk)
   BEGIN
      IF rising_edge(clk) THEN
         IF (reset = '1') THEN -- When reset is pressed, reset back to GAME START state 
            state <= S0;
         ELSE
            state <= next_state;
         END IF;

      END IF;
   END ARCHITECTURE Moore;