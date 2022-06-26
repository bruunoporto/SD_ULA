LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ULA IS
   PORT (
  CLOCK_50: in std_logic; 
  V_SW             : IN  std_logic_vector(3 DOWNTO 0); -- VSW(2 down to 0) : f(2 dowto 0); VSW(3) : C0;
  LEDG  : OUT std_logic_vector(7 DOWNTO 0) -- LED(3 downto 0) : soma; LED(4) : zero; LED(5) : negativo; LED(6) : carry_out; LED(7) : overlow;
  );
END ULA;

---------------------------------------------------------------------------------------------------------------
--Decoder: 
-- CLOCK_50: clock da placa FPGA - in;
-- AB: vetor de 8 bis contendo A e B respectivamente -in;
---------------------------------------------------------------------------------------------------------------
--Módulo combinacional:
-- V_SW(2 DOWNTO 0): seleção de função - in;
-- V_SW(3 DOWNTO 3): carry_in - in;
-- K_CAi: complemento de A;  
-- K_CBi:  complemento de B; 
--K_Mi: seleção do mux;
--C_ini: carry in do somador;
--K_DLi: controle do deslocador;
--------------------------------------------------------------------------------------------------------------
--Complemento:
-- K_CAi: controle do complemento de A - in;
--K_CBi: controle do complemento de B - in;
-- AB - vetor de 8 bis contendo A e B respectivamente -in;
-- CAi: novo valor de A (complementado ou não) - out;  
-- CBi:  novo valor de B (complementado ou não) - out; 
--------------------------------------------------------------------------------------------------------------
--Deslocador: 
-- K_DLi: controle de deslocamento de A - in;
--CAi : novo valor de A definido no componente complemento - in;
-- AB - vetor de 8 bis contendo A e B respectivamente -in;
-- OVFD: valor de overflow caso a multiplicação ultrapasse 4 bits - out;  
-- A_final:  novo valor de A (deslocado ou não) - out; 
--------------------------------------------------------------------------------------------------------------
--Mux: 
-- K_Mi: seleção do mux - in;
--CAi : novo valor de A definido no componente complemento - in;
--CBi : novo valor de B definido no componente complemento - in;
-- B - vetor de 8 bis contendo A e B respectivamente -in;
-- OVFD: valor de overflow caso a multiplicação ultrapasse 4 bits - out;  
-- B_final: novo valor de B (complemento de A, "0000", complemento de B) - out; 
--------------------------------------------------------------------------------------------------------------
--Somador: 
-- A_final: valor final de A - in;
-- B_final: valor final de B - in;
--C_ini : carry_in do somador definido no módulo combinacional - in;
--CBi : novo valor de B definido no componente complemento - in;
-- OVFD: valor de overflow caso a multiplicação ultrapasse 4 bits (definido no deslocador) - in;  
-- LEDG(3 DOWNTO 0): resultado final da operação - out;
-- LEDG(4): zero - out;
-- LEDG(5): negativo - out;
-- LEDG(6): carry_out - out;
--LEDG(7): overflow - out;
--------------------------------------------------------------------------------------------------------------

ARCHITECTURE TypeArchitecture OF ULA IS
signal K_CAi,K_CBi,OVFD, C_ini        :   std_logic_vector(0 DOWNTO 0); 
signal K_Mi,K_DLi                     : std_logic_vector(1 DOWNTO 0); 
signal CAi,CBi,A_final, B_final, Sum  : std_logic_vector(3 DOWNTO 0); 
signal AB  : std_logic_vector(7 DOWNTO 0); 

Component Modulo_combinacional IS
    PORT (
    f     : IN  std_logic_vector(2 DOWNTO 0);  
    C0    : IN std_logic_vector(0 DOWNTO 0);       
    K_CA,K_CB, C_ini        : OUT std_logic_vector(0 DOWNTO 0);                    
    K_M,K_DL        : OUT std_logic_vector(1 DOWNTO 0)  
    );

End component;
Component decoder IS
 port (CLOCK_50: in std_logic;
    S  : OUT std_logic_vector(7 DOWNTO 0) );
End component;
Component Complemento IS
    PORT (
    KC      : IN  std_logic_vector(0 DOWNTO 0) :="0";                   
    C         : IN  std_logic_vector(3 DOWNTO 0) := "0000"; 
    C_out        : OUT std_logic_vector(3 DOWNTO 0)
    );
End component;
Component Deslocador IS
   PORT (
    K_DL      : IN std_logic_vector(1 DOWNTO 0);                   
    C         : IN  std_logic_vector(3 DOWNTO 0); 
    Overflow     : OUT  std_logic_vector(0 DOWNTO 0);
    ADD_1        : OUT std_logic_vector(3 DOWNTO 0)
    );
End component;
Component mux_4_1 IS
   Port(CB, CA: in std_logic_vector(3 downto 0);
        km: in std_logic_vector(1 downto 0);
        ADD_2: out std_logic_vector(3 downto 0));
End component;
Component Somador IS
    PORT (
      A,B                                      : IN  std_logic_vector(3 DOWNTO 0); 
      C_in, OVF_DL	                            : IN std_logic_vector(0 DOWNTO 0); 
      zero, negativo, carry_out, overflow      : OUT std_logic_vector(0 DOWNTO 0);                                  
      S                                        : OUT std_logic_vector(3 DOWNTO 0)
  );
End component;

BEGIN
Dc: Decoder port map(CLOCK_50, AB); -- atualiza os valores de A e B
Mc: Modulo_combinacional port map(V_SW(2 DOWNTO 0), V_SW(3 DOWNTO 3), K_CAi(0 DOWNTO 0), K_CBi(0 DOWNTO 0), C_ini(0 DOWNTO 0), K_Mi(1 DOWNTO 0), K_DLi(1 DOWNTO 0)); -- Atualiza a função de acordo com as entradas
ComplA: Complemento port map(K_CAi(0 DOWNTO 0),AB(3 DOWNTO 0), CAi(3 DOWNTO 0)); -- Seleção de complemento de A ou A
ComplB: Complemento port map(K_CBi(0 DOWNTO 0), AB(7 DOWNTO 4), CBi(3 DOWNTO 0)); -- Seleção de complemento de B ou B
Desloc: Deslocador port map(K_DLi(1 DOWNTO 0), CAi(3 DOWNTO 0), OVFD(0 DOWNTO 0), A_final(3 DOWNTO 0)); -- Seleção de A deslocado para esquerda ou direita ou não deslocado
Mux: mux_4_1 port map(CBi(3 DOWNTO 0), CAi(3 DOWNTO 0), K_Mi(1 DOWNTO 0), B_final(3 DOWNTO 0)); -- Seleção do valor do segundo operando
Som: Somador port map(A_final(3 DOWNTO 0),B_final(3 DOWNTO 0), C_ini(0 DOWNTO 0), OVFD(0 DOWNTO 0),  LEDG(4 DOWNTO 4),  LEDG(5 DOWNTO 5),  LEDG(6 DOWNTO 6),  LEDG(7 DOWNTO 7), LEDG(3 DOWNTO 0)); -- Operação de soma dos operandos selecionados

END TypeArchitecture;
