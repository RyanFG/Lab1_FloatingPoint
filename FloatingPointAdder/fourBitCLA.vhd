LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fourBitCLA IS
	PORT(
		a,b: IN STD_LOGIC_VECTOR(3 downto 0);
		carryIn: IN STD_LOGIC;
		s: OUT STD_LOGIC_VECTOR(3 downto 0);
		carryOut: OUT STD_LOGIC
	);
END fourBitCLA;

ARCHITECTURE struct OF fourBitCLA IS
SIGNAL p,g: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL carry: STD_LOGIC_VECTOR(2 downto 0);

	COMPONENT lookaheadCell
		PORT(
			a,b: IN STD_LOGIC;
			carryIn: IN STD_LOGIC;
			s: OUT STD_LOGIC;
			p: OUT STD_LOGIC;
			g: OUT STD_LOGIC
		);
	END COMPONENT;

BEGIN

	cell1: lookaheadCell
		PORT MAP(
			a => a(0), b => b(0),
			carryIn => carryIn,
			s => s(0), p => p(0), g => g(0)
		);
	
	cell2: lookaheadCell
		PORT MAP(
			a => a(1), b => b(1),
			carryIn => carry(0),
			s => s(1), p => p(1), g => g(1)
		);
	
	cell3: lookaheadCell
		PORT MAP(
			a => a(2), b => b(2),
			carryIn => carry(1),
			s => s(2), p => p(2), g => g(2)
		);
		
	cell4: lookaheadCell
		PORT MAP(
			a => a(3), b => b(3),
			carryIn => carry(2),
			s => s(3), p => p(3), g => g(3)
		);
		
	carry(0) <= ((p(0))and(carryIn))or(g(0));
	carry(1) <= ((p(1))and(p(0))and(carryIn))or((p(1))and(g(0)))or(g(1));
	carry(2) <= ((p(2))and(p(1))and(p(0))and(carryIn))or((p(2))and(p(1))and(g(0)))or((p(2))and(g(1)))or(g(2));
	carryOut <= ((p(3))and(p(2))and(p(1))and(p(0))and(carryIn))or((p(3))and(p(2))and(p(1))and(g(0)))or((p(3))and(p(2))and(g(1)))
					or((p(3))and(g(2)))or(g(3));

END struct;