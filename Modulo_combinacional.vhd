LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Modulo_combinacional IS
  PORT (
    f     : IN  std_logic_vector(2 DOWNTO 0);  
    C0    : IN std_logic_vector(0 DOWNTO 0);       
    K_CA,K_CB, C_ini        : OUT std_logic_vector(0 DOWNTO 0);                    
    K_M,K_DL        : OUT std_logic_vector(1 DOWNTO 0)  
    );
END Modulo_combinacional;


ARCHITECTURE TypeArchitecture OF Modulo_combinacional IS

BEGIN
-- variáveis de controle e carry_in do somador definidos no pdf 
K_CA(0) <= f(1) and f(0);
K_CB(0)<= f(0);
K_M(0)<= f(1) or (f(2) and not(f(0)));
K_M(1)<= f(2) and not(f(1)) and f(0);
K_DL(0) <= f(2) and not(f(1));
K_DL(1) <= f(2) and f(1) and not(f(0)); 

C_ini(0) <= (not(f(2)) and (f(0) or f(1) or (not(f(1)) and not(f(0)) and C0(0))));  

END TypeArchitecture;
