LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Deslocador IS
  PORT (
    K_DL      : IN std_logic_vector(1 DOWNTO 0);                   
    C         : IN  std_logic_vector(3 DOWNTO 0); 

    Overflow     : OUT  std_logic_vector(0 DOWNTO 0);
    ADD_1        : OUT std_logic_vector(3 DOWNTO 0)
    );
END Deslocador;

ARCHITECTURE TypeArchitecture OF Deslocador IS
signal D,E :  std_logic_vector(3 DOWNTO 0); 
BEGIN
-- Deslocamento para esquerda
E(0) <= '0';
E(1) <= C(0);
E(2) <= C(1);
E(3) <= C(2);
-- Deslocamento para direita
D(0) <= C(1);
D(1) <= C(2);
D(2) <= C(3);
D(3) <= '0';

-- Caso o deslocamento para esquerda seja feito em um número maior que 7 ocorrerá Overflow, 
--pois o quarto bit será perdido
Overflow(0) <= C(3) when K_DL = "01" else '0';

-- Seleção do tipo de deslocamento
ADD_1 <=
D when  K_DL="10" else
E when K_DL="01" else
C;


END TypeArchitecture;
