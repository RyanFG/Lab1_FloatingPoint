LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY FPA_ControlPath IS
	PORT(
		reset,clk: IN STD_LOGIC;
		eDiffGZ,CntGZ: IN STD_LOGIC;
		eDiffZero,mDiffGZ: IN STD_LOGIC;
		RFBit7,REgreater63: IN STD_LOGIC;
	
		loadA,loadB: OUT STD_LOGIC;
		loadFx,loadFy: OUT STD_LOGIC;
		loadDiff,loadCnt: OUT STD_LOGIC;
		shiftFy,shiftFx: OUT STD_LOGIC;
		selAorCnt,selBorOne,selExpAorB: OUT STD_LOGIC;
		loadERes,loadMRes: OUT STD_LOGIC;
		loadResExp,loadResMant: OUT STD_LOGIC;
		shiftResMant: OUT STD_LOGIC;
		vectOrAdd1: OUT STD_LOGIC;
		invertCnt: OUT STD_LOGIC
	);
END FPA_ControlPath;

ARCHITECTURE struct OF FPA_ControlPath IS
SIGNAL s: STD_LOGIC_VECTOR(13 downto 0);

	COMPONENT newDFF
		PORT(	resetBar: IN STD_LOGIC;
				d: IN STD_LOGIC;
				enable: IN STD_LOGIC;
				clock: IN STD_LOGIC;
				q, qBar: OUT STD_LOGIC
		);
	END COMPONENT;

BEGIN

	state0: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => not((s(13))or(s(12))or(s(11))or(s(10))or(s(9))or(s(8))or(s(7))or(s(6))or(s(5))or(s(4))or(s(3))or(s(2))or(s(1))),
			q => s(0)
		);
	
	state1: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => s(0),
			q => s(1)
		);		
	
	state2: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => ((s(1))and(eDiffGZ))or((CntGZ)and(s(2))),
			q => s(2)
		);	
	
	state3: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => ((s(2))and(not(CntGZ))),
			q => s(3)
		);	
	
	state4: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => (s(12))or((s(4))and(CntGZ)),
			q => s(4)
		);	
	
	state5: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => ((s(4))and(not(CntGZ))),
			q => s(5)
		);	
	
	state6: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => ((s(5))and(eDiffZero)and(mDiffGZ))or((s(5))and(not(eDiffZero))),
			q => s(6)
		);	
	
	state7: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => ((s(5))and(not(mDiffGZ))and(eDiffZero)),
			q => s(7)
		);	
	
	state8: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => (s(7))or(s(6))or(s(3)),
			q => s(8)
		);	
	
	state9: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => ((s(13))and(RFBit7))or((s(10))and(RFBit7)),
			q => s(9)
		);	
	
	state10: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => ((s(13))and(not(RFBit7)))or((s(10))and(not(RFBit7))),
			q => s(10)
		);	
	
	state11: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => ((s(10))and(REgreater63)),
			q => s(11)
		);	
	
	state12: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => ((s(1))and(not(eDiffGZ))),
			q => s(12)
		);	
	
	state13: newDFF
		PORT MAP(
			resetBar => not(reset), clock => clk, enable => '1',
			d => s(8),
			q => s(13)
		);	
	
	loadA <= s(0);
	loadB <= s(0);
	loadFx <= (s(0))or(s(2));
	loadFy <= (s(0))or(s(4));
	
	loadDiff <= s(1);
	loadCnt <= (s(1))or(s(2))or(s(4))or(s(12));
	

	shiftFy <= s(2);
	selAorCnt <= (s(2))or(s(4));
	selBorOne <= (s(2))or(s(4));
	
	loadERes <= (s(3))or(s(5));
	

	shiftFx <= s(4);
	
	selExpAorB <= s(5);
	
	loadMRes <= s(8);
	
	loadResExp <= (s(10))or(s(13));
	loadResMant <= (s(10))or(s(13));
	shiftResMant <= s(10);
	vectOrAdd1 <= s(10);
	
	invertCnt <= s(12);
	
	
	
END struct;