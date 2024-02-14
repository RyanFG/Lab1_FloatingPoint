LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY exponentDatapath IS
	PORT(
		A,B: IN STD_LOGIC_VECTOR(6 downto 0);
		reset,clk: IN STD_LOGIC;
		selAorCnt,selBorOne,selExpAOrB: IN STD_LOGIC;
		loadA,loadB, invertCnt: IN STD_LOGIC;
		loadDiff,loadCnt,loadERes: IN STD_LOGIC;
		xGZ,yGZ: OUT STD_LOGIC;
		regRes: OUT STD_LOGIC_VECTOR(6 downto 0);
		eDiffOut: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END exponentDatapath;

ARCHITECTURE struct OF exponentDatapath IS
SIGNAL A_in,B_in,one: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL regA,regB,regDiff,regCnt,CntIn: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL CLA_out: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL a_MUX,b_MUX,expSelMUX: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL CLA_carryOut: STD_LOGIC;
SIGNAL regRes_in: STD_LOGIC_VECTOR(7 downto 0);

	COMPONENT eightBitRegister
		PORT(	resetBar, load, clock: IN STD_LOGIC;
				inValues: IN STD_LOGIC_VECTOR(7 downto 0);
				outValues: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT eightBitComparator
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
	
	COMPONENT sixteenToEightMUX
		PORT(	inA: IN STD_LOGIC_VECTOR(7 downto 0);
			inB: IN STD_LOGIC_VECTOR(7 downto 0);
			sel: IN STD_LOGIC;
			outC: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	

BEGIN
	
	A_in(6 downto 0) <= A(6 downto 0);
	A_in(7) <= '0';
	
	B_in(6 downto 0) <= B(6 downto 0);
	B_in(7) <= '0';
	
	one(0) <= '1';
	one(1) <= '0';
	one(2) <= '0';
	one(3) <= '0';
	one(4) <= '0';
	one(5) <= '0';
	one(6) <= '0';
	one(7) <= '0';
	
	
	registerA: eightBitRegister
		PORT MAP(
			resetBar => not(reset), load => loadA, clock => clk, 
			inValues => A_in,
			outValues => regA
		);
	
	registerB: eightBitRegister
	PORT MAP(
			resetBar => not(reset), load => loadB, clock => clk,
			inValues => B_in,
			outValues => regB
		);
	
	CntIn(0) <= CLA_Out(0);
	CntIn(1) <= CLA_Out(1);
	CntIn(2) <= (CLA_Out(2))xor(invertCnt);
	CntIn(3) <= (CLA_Out(3))xor(invertCnt);
	CntIn(4) <= (CLA_Out(4))xor(invertCnt);
	CntIn(5) <= (CLA_Out(5))xor(invertCnt);
	CntIn(6) <= (CLA_Out(6))xor(invertCnt);
	CntIn(7) <= (CLA_Out(7))xor(invertCnt);
	
	countReg: eightBitRegister
		PORT MAP(
			resetBar => not(reset), load => loadCnt, clock => clk, 
			inValues => CntIn,
			outValues => regCnt
		);
	
	diffReg: eightBitRegister
		PORT MAP(
			resetBar => not(reset), load => loadDiff, clock => clk, 
			inValues => CLA_out,
			outValues => regDiff
		);
		
	
	addOrSub: eightBitCLA
		PORT MAP(
			a => a_MUX,b => b_MUX,
			addOrSub => '0',
			carryIn => '0',
			s => CLA_out,
			carryOut => CLA_carryOut
		);
	
	greatZero: eightBitComparator
		PORT MAP(	
			x => regDiff,y => regCnt,
			xGreaterZero => xGZ,
			yGreaterZero => yGZ
		);
	
	CLA_aMUX: sixteenToEightMUX
		PORT MAP(	
			inA => regA,
			inB => regCnt,
			sel => selAorCnt,
			outC => a_MUX
		);
	
	CLA_bMUX: sixteenToEightMUX
		PORT MAP(	
			inA => regB,
			inB => one,
			sel => selBorOne,
			outC => b_MUX
		);
		
	expMUX: sixteenToEightMUX
		PORT MAP(	
			inA => regA,
			inB => regB,
			sel => selExpAOrB,
			outC => expSelMUX
		);
	
	resReg: eightBitRegister
		PORT MAP(
			resetBar => not(reset), load => loadERes, clock => clk, 
			inValues => expSelMUX,
			outValues => regRes_in
		);
		
	regRes(6 downto 0) <= regRes_in(6 downto 0);
	eDiffOut <= regDiff;
		
END struct;