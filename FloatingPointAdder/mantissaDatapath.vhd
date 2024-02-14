LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mantissaDatapath IS
	PORT(
		reset,clk: IN STD_LOGIC;
		loadFx,loadFy,loadRes: IN STD_LOGIC;
		shiftFx,shiftFy: IN STD_LOGIC;
		aMant,bMant: IN STD_LOGIC_VECTOR(7 downto 0);
		resOut: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END mantissaDatapath;

ARCHITECTURE struct OF mantissaDatapath IS
SIGNAL aShiftOut,bShiftOut, resShiftOut: STD_LOGIC;
SIGNAL aVect,bVect,adderOut,resVect: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL cOut: STD_LOGIC;

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

BEGIN
	
	aShiftReg: eightBitLeftShiftRegister
		PORT MAP(
			i_resetBar => not(reset), i_load => loadFx, i_shift => shiftFx,
			i_clock => clk, i_value => '0', 
			in_values => aMant,
			o_value => aShiftOut,
			o_vector => aVect
		);
	
	bShiftReg: eightBitLeftShiftRegister
		PORT MAP(
			i_resetBar => not(reset), i_load => loadFy, i_shift => shiftFy,
			i_clock => clk, i_value => '0', 
			in_values => bMant,
			o_value => bShiftOut,
			o_vector => bVect
		);

	adder: eightBitCLA
		PORT MAP(
			a => aVect, b => bVect,
			addOrSub => '0',
			carryIn => '0',
			s => adderOut,
			carryOut => cOut
		);

	resShiftReg: eightBitLeftShiftRegister
		PORT MAP(
			i_resetBar => not(reset), i_load => loadRes, i_shift => '0',
			i_clock => clk, i_value => '0', 
			in_values => adderOut,
			o_value => resShiftOut,
			o_vector => resOut
		);

	
END struct;