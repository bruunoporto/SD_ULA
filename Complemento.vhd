LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Complemento IS
  PORT (
    KC      : IN  std_logic_vector(0 DOWNTO 0):="0";                   
    C         : IN  std_logic_vector(3 DOWNTO 0):= "0000"; 
    C_out        : OUT std_logic_vector(3 DOWNTO 0)
    );
END Complemento;

ARCHITECTURE TypeArchitecture OF Complemento IS

BEGIN
-- KC => controla se o valor de saída será o valor da entrada ou o complemento do valor da entrada
C_out  <= C when KC(0)='0' else
not(C) when KC(0)='1';

END TypeArchitecture;