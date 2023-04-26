library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity random_number_generator is
    port(clk, reset: in std_logic;
    output: out std_logic_vector(2 downto 0)
    );
end entity random_number_generator;

architecture behaviour of random_number_generator is
    signal lsfr_reg : std_logic_vector(2 downto 0) := "100"; -- initialise seed
begin
    process(clk, reset)
    begin
        if reset = '1' then
            lsfr_reg <= "100"; -- reset to seed
        elsif rising_edge(clk) then
            lfsr_reg <= lfsr_reg(1 downto 0) & (lfsr_reg(2) XOR lfsr_reg(1) XOR lfsr_reg(0));
        end if;
    end process;

    output <= lsfr_reg;
end behaviour;