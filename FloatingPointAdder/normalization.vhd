LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY normalization IS
	PORT(
		reset,clk: IN STD_LOGIC;
		resMantVect: IN STD_LOGIC_VECTOR(7 downto 0);
		resExpVect: IN STD_LOGIC_VECTOR(6 downto 0);
		loadResExp,loadResMant: IN STD_LOGIC;
		shiftResMant: IN STD_LOGIC;
		vectOrAdd1: IN STD_LOGIC;
		resMantFinal: OUT STD_LOGIC_VECTOR(7 downto 0);
		resExpFinal: OUT STD_LOGIC_VECTOR(6 downto 0);
		normalized: OUT STD_LOGIC;
		overflow: OUT STD_LOGIC
	);
END normalization;

ARCHITECTURE struct OF normalization IS
SIGNAL resMantOut,resExpOut: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL resExpAdd1,ExpMUX,one: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL cOut,shiftMantOut,shiftExpOut: STD_LOGIC;
	
	COMPONENT eightBitLeftShiftRegister
		PORT(
			i_resetBar, i_load, i_shift: IN STD_LOGIC;
			i_clock: IN STD_LOGIC;
			i_value: IN STD_LOGIC;
			in_values:IN STD_LOGIC_VECTOR(7 downto 0);
			o_Value: OUT STD_LOGIC;
			o_vector: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT eightBitCLA
		PORT(
			a,b: IN STD_LOGIC_VECTOR(7 downto 0);
			addOrSub: IN STD_LOGIC;
			carryIn: IN STD_LOGIC;
			s: OUT STD_LOGIC_VECTOR(7 downto 0);
			carryOut: OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT eightBitComparator
		PORT(	x,y: IN STD_LOGIC_VECTOR(7 downto 0);
				eq: OUT STD_LOGIC;
				xGreaterZero: OUT STD_LOGIC;
				yGreaterZero: OUT STD_LOGIC;
				bitX7Eq1: OUT STD_LOGIC;
				bitY7Eq1: OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT sixteenToEightMUX
		PORT(	inA: IN STD_LOGIC_VECTOR(7 downto 0);
			inB: IN STD_LOGIC_VECTOR(7 downto 0);
			sel: IN STD_LOGIC;
			outC: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
BEGIN
	
	one(0) <= '1';
	one(1) <= '0';
	one(2) <= '0';
	one(3) <= '0';
	one(4) <= '0';
	one(5) <= '0';
	one(6) <= '0';
	one(7) <= '0';
	
	resMant: eightBitLeftShiftRegister
		PORT MAP(
			i_resetBar => not(reset), i_load => loadResMant, i_shift => shiftResMant,
			i_clock => clk,
			i_value => '0',
			in_values => resMantVect,
			o_Value => shiftMantOut,
			o_vector => resMantOut
		);
 	
	MUX1: sixteenToEightMUX
		PORT MAP(
			inA(6 downto 0) => resExpVect(6 downto 0),
			inA(7) => '0',
			inB => resExpAdd1,
			sel => vectOrAdd1,
			outC => ExpMUX
		);
	
	resExp: eightBitLeftShiftRegister
		PORT MAP(
			i_resetBar => not(reset), i_load => loadResExp, i_shift => '0',
			i_clock => clk,
			i_value => '0',
			in_values => ExpMUX,
			o_Value => shiftExpOut,
			o_vector => resExpOut
		);
	
	add1: eightBitCLA
		PORT MAP(
			a => resExpOut, b => one,
			addOrSub => '0',
			carryIn => '0',
			s => resExpAdd1,
			carryOut => cOut
		);
		
	compTo1: eightBitComparator
		PORT MAP(
			x => resMantOut,y => resMantOut,
			bitY7Eq1 => normalized
		);
		
	--Output Driver
	resMantFinal <= resMantOut;
	resExpFinal <= resExpOut(6 downto 0);
	overflow <= resExpOut(7);
	
END struct;