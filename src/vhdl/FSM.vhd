LIBRARY IEEE;
USE iee.std_logic_1164.ALL;

-- CUSTOM STATE TYPE
TYPE state_types IS (menu, normal_game, training_mode, game_over);

ENTITY FSM IS

   PORT (
      clk_in, collision, mode : IN STD_LOGIC;
      state_in : IN STD_LOGIC_VECTOR(1 downto 0); -- 4 different states possible so input is 
      state_out : OUT STD_LOGIC_VECTOR(1 downto 0); -- Output of FSM is game state (menu, NORMAL GAME, GAME OVER, training)

   );
END ENTITY FSM;

ARCHITECTURE Moore OF FSM IS
   -- define states
   type state_type is (game_start, normal_mode, training_mode, game_over);
   SIGNAL current_state, next_state : state_type;

BEGIN
   -- Process used to update the next state of game every clock cycle
   state_sync : PROCESS (clk_in)
   BEGIN
      if(reset = '1') then
         current_state <= game_start;
      elsif rising_edge(clk_in) THEN
            state_out <= next_state;
      end if;
   END PROCESS state_sync;

   -- process to describe state transitions
   process transition(current_state, collision, mode)
   BEGIN
      CASE (current_state) IS
         WHEN game_start =>
            if mode = '1' then
               next_state <= normal_mode;
            else
               next_state <= training_mode;
            end if;
         WHEN normal_game =>
            if collision = '1' then
               next_state <= game_over;
            else
               next_state <= normal_game;
            end if;
         WHEN game_over =>
            if(mode = '1') then
               next_state <= normal_mode;
            else
               next_state <= training_mode;
            end if;
         WHEN training =>
            if collision = '1' then
               next_state <= game_over;
            else
               next_state <= training_mode;
            end if;
      END CASE;
      state_in <= current_state; -- assign current state 
   end process;

END ARCHITECTURE Moore;