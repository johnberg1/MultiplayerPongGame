library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clock is
    Port ( clock_in : in STD_LOGIC;
           clock_out : out STD_LOGIC);
end clock;

architecture Behavioral of clock is


signal temp : STD_LOGIC:='0';
signal count: integer range 0 to 1000000000;

begin
process(clock_in)
    begin
        if(rising_edge(clock_in)) then
            if(count = 100000000) then
                temp <= not temp;
                count <= 0;
            else
                count <= count + 1;
            end if;
        end if;
end process;

clock_out <= temp; 

end Behavioral;