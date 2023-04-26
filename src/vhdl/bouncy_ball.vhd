LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bouncy_ball IS
	PORT
		( pb1, pb2, clk, vert_sync, left_button	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  game_state : IN std_logic_vector(1 downto 0); -- 00 game over, 01 game start, 10 gameplay
		  red, green, blue 			: OUT std_logic);		
END bouncy_ball;

architecture behavior of bouncy_ball is

SIGNAL ball_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos				: std_logic_vector(9 DOWNTO 0);
SIGNAL ball_x_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL ball_y_motion			: std_logic_vector(9 DOWNTO 0);
SIGNAL ascending_flag 			: std_logic := '0';
SIGNAL max_frames_ascending 	: Integer := 30;
SIGNAL frame_count : Integer := 0;
SIGNAL click_disabled : std_logic := '0';

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(8,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
ball_x_pos <= CONV_STD_LOGIC_VECTOR(590,11);

ball_on <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';


-- Colours for pixel data on video signal
-- Changing the background and ball colour by pushbuttons
Red <=  pb1;
Green <= (not pb2) and (not ball_on);
Blue <=  not ball_on;



Move_Ball: process (vert_sync) -- Add left_button to sensitivity list
begin
	if Rising_Edge(vert_sync) then
		if left_button = '1' then
			-- Go up
			if ball_y_pos > 0 then -- Check if ball is not at the top of the screen
				ball_y_motion <= -CONV_STD_LOGIC_VECTOR(5, 10); -- Set upward motion
			else
				ball_y_motion <= (others => '0'); -- Dont move
			end if;
		else
			-- Apply gravity
			if ball_y_pos < (CONV_STD_LOGIC_VECTOR(479,10) - size) then -- Check if ball is not at the bottom of the screen
				if ball_y_motion < CONV_STD_LOGIC_VECTOR(10, 10) then -- Limit fall speed
					ball_y_motion <= ball_y_motion + CONV_STD_LOGIC_VECTOR(1, 10); -- Make it fall faster
				end if;
			else
				ball_y_motion <= (others => '0'); -- Stop downward motion
			end if;
		end if;
		if ball_y_pos + ball_y_motion >= (CONV_STD_LOGIC_VECTOR(479,10) - size) then
			ball_y_pos <= CONV_STD_LOGIC_VECTOR(479,10) - size; --Make it fall to bottom gracefully
		else
			ball_y_pos <= ball_y_pos + ball_y_motion; -- normal
		end if;

	end if;
end process Move_Ball;


END behavior;

