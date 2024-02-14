LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY eightBitComparator IS
	PORT(	x,y: IN STD_LOGIC_VECTOR(7 downto 0);
			eq: OUT STD_LOGIC;
			xGreaterZero: OUT STD_LOGIC;
			yGreaterZero: OUT STD_LOGIC;
			bitX7Eq1: OUT STD_LOGIC;
			bitY7Eq1: OUT STD_LOGIC;
			xEqZero, yEqZero: OUT STD_LOGIC;
			xGZ_US8Bit, yGZ_US8Bit: OUT STD_LOGIC;
			xEqZero_8Bit, yEqZero_8Bit: OUT STD_LOGIC
	);
END eightBitComparator;

ARCHITECTURE struct OF eightBitComparator IS
SIGNAL eq0to3,eq4to7: STD_LOGIC;

	COMPONENT comparator
		PORT(	
			x,y: IN STD_LOGIC_VECTOR(3 downto 0);
			eq: OUT STD_LOGIC
		);
	END COMPONENT;
	
BEGIN

	eq1: comparator
		PORT MAP(
			x => x(3 downto 0),
			y => y(3 downto 0),
			eq => eq0to3
		);
		
	eq2: comparator
		PORT MAP(
			x => x(7 downto 4),
			y => y(7 downto 4),
			eq => eq4to7
		);
		
	eq <= (eq0to3)and(eq4to7);
	
	xGreaterZero <= (not(x(6)))and((x(5))or(x(4))or(x(3))or(x(2))or(x(1))or(x(0)));
	yGreaterZero <= (not(y(6)))and((y(5))or(y(4))or(y(3))or(y(2))or(y(1))or(y(0)));
	
	xEqZero <= not((x(6))or(x(5))or(x(4))or(x(3))or(x(2))or(x(1))or(x(0)));
	yEqZero <= not((y(6))or(y(5))or(y(4))or(y(3))or(y(2))or(y(1))or(y(0)));
	
	xGZ_US8Bit <= (x(7))or(x(6))or(x(5))or(x(4))or(x(3))or(x(2))or(x(1))or(x(0));
	yGZ_US8Bit <= (y(7))or(y(6))or(y(5))or(y(4))or(y(3))or(y(2))or(y(1))or(y(0));
	
	xEqZero_8Bit <= not((x(7))or(x(6))or(x(5))or(x(4))or(x(3))or(x(2))or(x(1))or(x(0)));
	yEQZero_8Bit <= not((y(7))or(y(6))or(y(5))or(y(4))or(y(3))or(y(2))or(y(1))or(y(0)));
	
	bitX7Eq1 <= (x(7))and('1');
	bitY7Eq1 <= (y(7))and('1');

END struct;