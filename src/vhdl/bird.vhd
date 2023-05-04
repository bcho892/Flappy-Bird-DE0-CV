LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bird IS
	PORT
		(vert_sync, left_click, pipe_on	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  game_state : IN std_logic_vector(1 downto 0); -- 00 game over, 01 game start, 10 gameplay
		  bird_on, collision, red, green, blue 			: OUT std_logic);		-- collision is also connected to the FSM
END bird;

architecture behavior of bird is

SIGNAL temp_bird_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL bird_y_pos				: std_logic_vector(9 DOWNTO 0);
SIGNAL bird_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL bird_y_motion			: std_logic_vector(9 DOWNTO 0);

-- CONSTANTS
CONSTANT ACCELERATION_RATE_DOWN : STD_LOGIC_VECTOR := CONV_STD_LOGIC_VECTOR(1,10);
CONSTANT UPWARDS_SPEED : STD_LOGIC_VECTOR := CONV_STD_LOGIC_VECTOR(8, 10);
CONSTANT MAX_FALL_SPEED : STD_LOGIC_VECTOR := CONV_STD_LOGIC_VECTOR(11, 10);
CONSTANT GROUND_Y_PIXEL : STD_LOGIC_VECTOR := CONV_STD_LOGIC_VECTOR(420,10);
CONSTANT CENTRE : STD_LOGIC_VECTOR := CONV_STD_LOGIC_VECTOR(420,10);
BEGIN           

size <= CONV_STD_LOGIC_VECTOR(8,10);
-- bird_x_pos and bird_y_pos show the (x,y) for the centre of ball
bird_x_pos <= CONV_STD_LOGIC_VECTOR(300,11);

temp_bird_on <= '1' when ( ('0' & bird_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & bird_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & bird_y_pos <= pixel_row + size) and ('0' & pixel_row <= bird_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';

collision <= '1' when temp_bird_on = '1' and pipe_on = '1' else '0';

Blue <= temp_bird_on;
bird_on <= temp_bird_on;


Move_Bird: process (vert_sync) -- Add left_click to sensitivity list
begin
	case state_in IS
		when "00" => -- start menu
			if(RISING_EDGE(vert_sync) then
				bird_y_pos <= CENTRE;
			end if;
		when "11" => -- game over
			if(RISING_EDGE(vert_sync) then
				bird_y_pos <= CENTRE;
			end if;
			
		when others => -- normal operation and training- bird behaviour is the same
		if Rising_Edge(vert_sync) then
			if left_click = '1' then
				-- Go up
				if bird_y_pos > 0 then -- Check if ball is not at the top of the screen
					bird_y_motion <= -UPWARDS_SPEED; -- Set upward motion
				else
					bird_y_motion <= (others => '0'); -- Dont move
				end if;
			else
				-- Apply gravity
				if bird_y_pos < (GROUND_Y_PIXEL - size) then -- Check if ball is not at the bottom of the screen
					if bird_y_motion < MAX_FALL_SPEED then -- Limit fall speed
						bird_y_motion <= bird_y_motion + ACCELERATION_RATE_DOWN; -- Make it fall faster
					end if;
				else
					bird_y_motion <= (others => '0'); -- Stop downward motion
				end if;
			end if;
			if bird_y_pos + bird_y_motion >= (GROUND_Y_PIXEL - size) then
				bird_y_pos <= GROUND_Y_PIXEL - size; --Make it fall to bottom gracefully
			else
				bird_y_pos <= bird_y_pos + bird_y_motion; -- normal
			end if;
	
		end if;
	end case;

end process Move_Bird;


END behavior;

