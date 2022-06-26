library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity counter is
    generic(t_max : integer := 100000000); 
    port(CLOCK_50: in std_logic;
    counter_outA,counter_outB : out unsigned(3 downto 0) := "0000"
    );
end counter;

architecture behavioral of counter is

signal counter_tempA, counter_tempB: unsigned(3 downto 0) := "0000";

begin
    counter_label: process (CLOCK_50) 
    variable slow_clock: integer range t_max downto 0 := 0; 
    begin
       if (CLOCK_50'event and CLOCK_50='1') then -- quando o tempo é menor que o tempo máximo nada acontecd
        if (slow_clock <= t_max) then
            slow_clock := slow_clock + 1;
        else -- quando é maior o valor de A é acrescido de 1
            counter_tempA <= counter_tempA + 1; 
            if (counter_tempA = 15) then -- quando A chega em 15, o soma-se 1 no B
                counter_tempB <= counter_tempB + 1;
            end if;
            slow_clock := 0;
        
        end if;
       end if;
    end process;
    counter_outA<= counter_tempA;
    counter_outB <= counter_tempB;
    
end behavioral;