LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY lookaheadCell IS
	PORT(
		a,b: IN STD_LOGIC;
		carryIn: IN STD_LOGIC;
		s: OUT STD_LOGIC;
		p: OUT STD_LOGIC;
		g: OUT STD_LOGIC
	);
END lookaheadCell;

ARCHITECTURE struct OF lookaheadCell IS

BEGIN

	s <= (a)xor(b)xor(carryIn);
	
	p <= (a)or(b);
	g <= (a)and(b);

END struct;