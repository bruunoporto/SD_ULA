library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity decoder is
    port (CLOCK_50: in std_logic;
    S  : OUT std_logic_vector(7 DOWNTO 0) );
end decoder;



architecture TypeArchitecture of decoder is
    signal counter_A, counter_B: unsigned(3 downto 0) := "0000";
    signal A, B: std_logic_vector(3 downto 0) := "0000";

    component counter is
        port(CLOCK_50: in std_logic;
        counter_outA, counter_outB : out unsigned(3 downto 0) := "0000"
        );
    end component;


begin
    counter0: counter port map(CLOCK_50, counter_A, counter_B); -- a cada ciclo do clock da placa ele atualiza o valor de counter_A e counter_B;
    
   -- Decodificando A e B de acordo com o valor do contador
     A <= "0000" when counter_A = 0 else -- 0
    "0001" when  counter_A= 1 else  -- 1
    "0010" when  counter_A= 2 else  -- 2
    "0011" when counter_A =  3 else  -- 3
    "0100" when  counter_A = 4 else  -- 4
    "0101" when  counter_A = 5 else  -- 5
    "0110" when counter_A = 6 else  -- 6
    "0111" when counter_A= 7 else  -- 7
    "1000" when  counter_A = 8 else  -- 8
    "1001" when  counter_A = 9 else  -- 9
    "1010" when  counter_A = 10 else  -- 7
    "1011" when  counter_A = 11 else  -- 8
    "1100" when  counter_A = 12 else
    "1101" when  counter_A = 13 else  -- 8
    "1110" when  counter_A = 14 else
    "1111" when  counter_A = 15 else  -- 8
    "0000";  -- null
    
     B <= "0000" when counter_B = 0 else -- 0
    "0001" when  counter_B= 1 else  -- 1
    "0010" when  counter_B= 2 else  -- 2
    "0011" when counter_B =  3 else  -- 3
    "0100" when  counter_B = 4 else  -- 4
    "0101" when  counter_B = 5 else  -- 5
    "0110" when counter_B = 6 else  -- 6
    "0111" when counter_B= 7 else  -- 7
    "1000" when  counter_B = 8 else  -- 8
    "1001" when  counter_B = 9 else  -- 9
    "1010" when  counter_B = 10 else  -- 7
    "1011" when  counter_B = 11 else  -- 8
    "1100" when  counter_B = 12 else
    "1101" when  counter_B = 13 else  -- 8
    "1110" when  counter_B = 14 else
    "1111" when  counter_B = 15 else  -- 8
    "0000";  -- null
    
    -- Criando um vetor de 7 bits com os A e B respectivamente.
    S(3 downto 0) <= A;
    S(7 downto 4) <= B;
    
end TypeArchitecture;

