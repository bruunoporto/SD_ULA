LIBRARY ieee;
USE ieee.std_logic_1164.all;

Entity mux_4_1 is
Port(CB, CA: in std_logic_vector(3 downto 0);
km: in std_logic_vector(1 downto 0);
ADD_2: out std_logic_vector(3 downto 0));

End mux_4_1;
--Km recebe K_Mi: "00" -> CB; "01" -> CA; "01" -> "0000";
Architecture dataflow of mux_4_1 is
Begin
	with km select
		ADD_2 <= CB when "00",
		CA when "10",
		"0000" when others;

End dataflow;