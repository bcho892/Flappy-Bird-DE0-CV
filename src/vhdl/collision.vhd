LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;
USE IEEE.NUMERIC_STD;

entity collision is 
	PORT (bird_on, pipe_on, vert_sync: in std_logic;
            collision_detected: out std_logic      
    );
end entity collision;

architecture behaviour of collision is
begin  
    process(vert_sync)
    begin
        if(Rising_Edge(vert_sync)) then
            -- check collision
            if(bird_on = '1' and pipe_on = '1') then
                collision_detected <= '0';
            else
                collision_detected <= '1';
            end if;
        end if;
    end process;

end behaviour;

