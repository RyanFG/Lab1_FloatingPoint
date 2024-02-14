LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY eightBitCLA IS 
	PORT(
		a,b: IN STD_LOGIC_VECTOR(7 downto 0);
		addOrSub: IN STD_LOGIC;
		carryIn: IN STD_LOGIC;
		s: OUT STD_LOGIC_VECTOR(7 downto 0);
		carryOut: OUT STD_LOGIC
	);
END eightBitCLA;

ARCHITECTURE struct OF eightBitCLA IS
SIGNAL CLA1_carry: STD_LOGIC;
SIGNAL b_in: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL first_one: STD_LOGIC_VECTOR(7 downto 0);

	COMPONENT fourBitCLA
		PORT(
			a,b: IN STD_LOGIC_VECTOR(3 downto 0);
			carryIn: IN STD_LOGIC;
			s: OUT STD_LOGIC_VECTOR(3 downto 0);
			carryOut: OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT firstOne
		PORT(
			A: IN STD_LOGIC_VECTOR(7 downto 0);
			one: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;

BEGIN

	first: firstOne
		PORT MAP(
			A => b,
			one => first_one
		);
	
	b_in(0) <= (b(0))xor((addOrSub)and(not(first_one(0))));
	b_in(1) <= (b(1))xor((addOrSub)and(not(first_one(1))));
	b_in(2) <= (b(2))xor((addOrSub)and(not(first_one(2))));
	b_in(3) <= (b(3))xor((addOrSub)and(not(first_one(3))));
	b_in(4) <= (b(4))xor((addOrSub)and(not(first_one(4))));
	b_in(5) <= (b(5))xor((addOrSub)and(not(first_one(5))));
	b_in(6) <= (b(6))xor((addOrSub)and(not(first_one(6))));
	b_in(7) <= (b(7))xor((addOrSub)and(not(first_one(7))));

	CLA1: fourBitCLA
		PORT MAP(
			a => a(3 downto 0), b => b_in(3 downto 0),
			carryIn => carryIn,
			s => s(3 downto 0),
			carryOut => CLA1_carry
		);
	
	CLA2: fourBitCLA
		PORT MAP(
			a => a(7 downto 4), b => b_in(7 downto 4),
			carryIn => carryIn,
			s => s(7 downto 4),
			carryOut => CLA1_carry
		);

END struct;