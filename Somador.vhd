LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- Full Adder --
ENTITY Somador IS
  PORT (
  A,B                                      : IN  std_logic_vector(3 DOWNTO 0); 
  C_in, OVF_DL	                            : IN std_logic_vector(0 DOWNTO 0); 
  zero, negativo, carry_out, overflow      : OUT std_logic_vector(0 DOWNTO 0);                                  
  S                                        : OUT std_logic_vector(3 DOWNTO 0)
  );
END Somador;

ARCHITECTURE TypeArchitecture OF Somador IS

signal C : std_logic_vector(4 DOWNTO 1);
signal Z : std_logic_vector(3 DOWNTO 0);
BEGIN

-- Carry look-ahead --> C(n) = (A(n-1) and B(n-1)) or (A(n-1) and B(n-1) and C0); 
C(1) <= (A(0) and B(0)) or ((A(0) or B(0)) and C_in(0)); --
C(2) <= (A(1) and B(1)) or ((A(1) or B(1)) and C(1));
C(3) <= (A(2) and B(2)) or ((A(2) or B(2)) and C(2));
C(4) <= (A(3) and B(3)) or ((A(3) or B(3)) and C(3));

-- Soma - Z(n) = (A(n) xor B(n)) xor carry(n);  
Z(0) <= (A(0) xor B(0)) xor C_in(0);
Z(1) <= (A(1) xor B(1)) xor C(1);
Z(2) <= (A(2) xor B(2)) xor C(2);
Z(3) <= (A(3) xor B(3)) xor C(3);

-- Atribui o signal ao output
S(0) <= Z(0);
S(1) <= Z(1);
S(2) <= Z(2);
S(3) <= Z(3);

-- Definindo as flags
carry_out(0) <= C(4);
overflow(0) <= (C(3) xor C(4)) or OVF_DL(0); -- terá overflow caso a soma ou o deslocador tenham overflow 
zero(0) <= (not(Z(0)) and not(Z(1)) and not(Z(2)) and not(Z(3))); -- caso todos os bits sejam da soma sejam 0;
negativo(0) <= Z(3); -- caso o bit mais significativo da soma seja 1;

END TypeArchitecture;

