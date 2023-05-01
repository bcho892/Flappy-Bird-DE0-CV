library ieee;
use NUMERIC_STD;

entity collision is 
    PORT (bird_on, pipe_on, vert_sync: in std_logic;
            collision_detected: out std_logic      
    );
end entity collision;

architecture behaviour of collision is
    
    process(vert_sync)
    begin
        if(Rising_Edge(vert_sync)) then
            -- check collision
            if(bird_on and pipe_on) then
                collision_detected <= '1';
            else
                collision_detected <= '0';
            end if;
        end if;
    end process;

end behaviour;

