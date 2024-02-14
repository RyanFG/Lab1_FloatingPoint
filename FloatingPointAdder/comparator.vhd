LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY comparator IS
	PORT(	x,y: IN STD_LOGIC_VECTOR(3 downto 0);
			eq: OUT STD_LOGIC
	);
END comparator;

ARCHITECTURE struct OF comparator IS

BEGIN

	eq <= ((x(0))xnor(y(0)))and((x(1))xnor(y(1)))and((x(2))xnor(y(2)))and((x(3))xnor(y(3)));
	
END struct;