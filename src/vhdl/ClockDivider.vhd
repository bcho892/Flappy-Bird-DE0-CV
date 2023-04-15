entity clock_divider is
    port(
      clk_in : in std_logic;
      clk_out : out std_logic
    );
  end entity clock_divider;
  
  architecture behaviour of clock_divider is
    signal counter : integer range 0 to 1 := 0;
  begin
    process(clk_in)
    begin
      if rising_edge(clk_in) then
        counter <= counter + 1;
        if counter = 2 then
          counter <= 0;
          clk_out <= not clk_out;
        end if;
      end if;
    end process;
  end architecture behaviour;
  
