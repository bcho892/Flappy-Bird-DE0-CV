LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bird IS
	PORT
		(clk, vert_sync, left_click, pipe_on	: IN std_logic;
		character_select : IN STD_LOGIC_VECTOR(1 downto 0);
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  game_state : IN std_logic_vector(1 downto 0); -- 00 game over, 01 game start, 10 gameplay
		  bird_on, collision, red, green, blue, mode 			: OUT std_logic);		-- collision and mode are connected to the FSM
END bird;

architecture behavior of bird is
	-- CONSTANTS
	CONSTANT ACCELERATION_RATE_DOWN : STD_LOGIC_VECTOR := CONV_STD_LOGIC_VECTOR(1,10);
	CONSTANT UPWARDS_SPEED : STD_LOGIC_VECTOR := CONV_STD_LOGIC_VECTOR(8, 10);
	CONSTANT MAX_FALL_SPEED : STD_LOGIC_VECTOR := CONV_STD_LOGIC_VECTOR(11, 10);
	CONSTANT BIRD_SCALE : STD_LOGIC_VECTOR := CONV_STD_LOGIC_VECTOR(2, 10);
	CONSTANT GROUND_Y_PIXEL : STD_LOGIC_VECTOR := CONV_STD_LOGIC_VECTOR(420,10);

SIGNAL temp_bird_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(24,10);
SIGNAL bird_y_pos				: std_logic_vector(9 DOWNTO 0);
SIGNAL bird_x_pos				: std_logic_vector(9 DOWNTO 0);
SIGNAL bird_y_motion			: std_logic_vector(9 DOWNTO 0);
SIGNAL character_address 		: std_logic_vector(5 DOWNTO 0);

component sprite 
	generic (
			scale : STD_LOGIC_VECTOR	
			);
	port (
			clk, reset, horiz_sync : IN STD_LOGIC;
			rom_address : IN STD_LOGIC_VECTOR(5 downto 0);
			sprite_row, sprite_column, 
			pixel_row, pixel_column : IN STD_LOGIC_VECTOR(9 downto 0);
			sprite_on: OUT STD_LOGIC
		 );
end component;

BEGIN           

bird_x_pos <= CONV_STD_LOGIC_VECTOR(300,10);
with character_select select character_address <=
	CONV_STD_LOGIC_VECTOR(27,6) when "00",
	CONV_STD_LOGIC_VECTOR(0, 6) when "01",
	CONV_STD_LOGIC_VECTOR(7, 6) when "10",
	CONV_STD_LOGIC_VECTOR(9, 6) when others;

sprite_component : sprite 
generic map(
			BIRD_SCALE
		   ) port map( clk, '0', vert_sync, character_address,bird_y_pos,bird_x_pos, pixel_row, pixel_column, temp_bird_on
		);

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
			if(left_click = '1') then
				mode = '1';
			end if;
		when "11" => -- game over
			if(RISING_EDGE(vert_sync) then
				bird_y_pos <= CENTRE;
			end if;

		when others => -- normal operation and training- bird behaviour is the same
		if Rising_Edge(vert_sync) then
			-- ground collision
			if(bird_y_pos = GROUND_Y_PIXEL) then
				collision <= '1';
			end if;

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

