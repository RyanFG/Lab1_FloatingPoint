LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY floatingPointAdder IS
	PORT(	reset,clk: IN STD_LOGIC;
			signA,signB: IN STD_LOGIC;
			mantA,mantB: IN STD_LOGIC_VECTOR(3 downto 0);
			expA: IN STD_LOGIC_VECTOR(2 downto 0);
			expB: IN STD_LOGIC_VECTOR(3 downto 0);
			signO: OUT STD_LOGIC;
			mantO: OUT STD_LOGIC_VECTOR(7 downto 0);
			expO: OUT STD_LOGIC_VECTOR(6 downto 0);
			overflow: OUT STD_LOGIC
	);
END floatingPointAdder;

ARCHITECTURE struct OF floatingPointAdder IS
SIGNAL loadA,loadB: STD_LOGIC;
SIGNAL loadFx,loadFy: STD_LOGIC;
SIGNAL loadDiff,loadCnt: STD_LOGIC;
SIGNAL shiftFx,shiftFy: STD_LOGIC;
SIGNAL selAorCnt,selBorOne,selExpAorB: STD_LOGIC;
SIGNAL loadERes,loadMRes: STD_LOGIC;
SIGNAL loadResExp,loadResMant: STD_LOGIC;
SIGNAL shiftResMant: STD_LOGIC;
SIGNAL vectOrAdd1,invertCnt: STD_LOGIC;
SIGNAL eDiffGZ,CntGZ: STD_LOGIC;
SIGNAL eDiffZero, mDiffGZ: STD_LOGIC;
SIGNAL RFBit7,REgreater63: STD_LOGIC;
SIGNAL expAin,expBin: STD_LOGIC_VECTOR(6 downto 0);
SIGNAL mantAin,mantBin: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL start: STD_LOGIC;

	COMPONENT FPA_Datapath
		PORT(
			reset,clk: IN STD_LOGIC;
			aInExp,bInExp: IN STD_LOGIC_VECTOR(6 downto 0);
			aInMant,bInMant: IN STD_LOGIC_VECTOR(7 downto 0);
			aSign,bSign: IN STD_LOGIC;
			selExpAOrB,selAorCnt,selBorOne: IN STD_LOGIC;
			loadAExp,loadBExp,loadDiff,loadCnt: IN STD_LOGIC;
			invertCnt,loadERes: IN STD_LOGIC;
			loadFx,loadFy,loadMRes: IN STD_LOGIC;
			shiftFx,shiftFy: IN STD_LOGIC;
			loadResExp,loadResMant: IN STD_LOGIC;
			shiftResMant, vectOrAdd1: IN STD_LOGIC;
			
			resSign: OUT STD_LOGIC;
			resMantFinal: OUT STD_LOGIC_VECTOR(7 downto 0);
			resExpFinal: OUT STD_LOGIC_VECTOR(6 downto 0);
			xGZ,yGZ: OUT STD_LOGIC;
			eDiffEqZero,mantDiffGZ: OUT STD_LOGIC;
			normalized: OUT STD_LOGIC;
			overflow: OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT FPA_ControlPath
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
	END COMPONENT;
	
BEGIN

	expAin(1 downto 0 ) <= expA(1 downto 0);
	expAin(2) <= '1';
	expAin(3) <= '1';
	expAin(4) <= '1';
	expAin(5) <= '1';
	expAin(6) <= expA(2);
	
	mantAin(3 downto 0) <= mantA(3 downto 0);
	mantAin(4) <= '1';
	mantAin(5) <= '1';
	mantAin(6) <= '1';
	mantAin(7) <= '1';
	
	expBin(2 downto 0 ) <= expB(2 downto 0);
	expBin(3) <= '1';
	expBin(4) <= '1';
	expBin(5) <= '1';
	expBin(6) <= expB(3);
	
	mantBin(3 downto 0) <= mantB(3 downto 0);
	mantBin(4) <= '1';
	mantBin(5) <= '1';
	mantBin(6) <= '1';
	mantBin(7) <= '1';
	
	datapath: FPA_Datapath
		PORT MAP(
			reset => reset, clk => clk,
			aInExp => expAin, bInExp => expBin,
			aInMant => mantAin, bInMant => mantBin,
			aSign => signA, bSign => signB,
			selExpAOrB => selExpAorB, selAorCnt => selAorCnt, selBorOne => selBorOne,
			loadAExp => loadA, loadBExp => loadB, loadDiff => loadDiff, loadCnt => loadCnt,
			invertCnt => invertCnt, loadERes => loadERes,
			loadFx => loadFx, loadFy => loadFy, loadMRes => loadMRes,
			shiftFx => shiftFx, shiftFy => shiftFy,
			loadResExp => loadResExp, loadResMant => loadResMant,
			shiftResMant => shiftResMant, vectOrAdd1 => vectOrAdd1,
			
			resSign => signO,
			resMantFinal => mantO,
			resExpFinal => expO,
			xGZ => eDiffGZ, yGZ => CntGZ,
			eDiffEqZero => eDiffZero, mantDiffGZ => mDiffGZ,
			normalized => RFBit7,
			overflow => REgreater63
		);
	
	controlPath: FPA_ControlPath
		PORT MAP(
			reset => reset, clk => clk,
			eDiffGZ => eDiffGZ, CntGZ => CntGZ,
			eDiffZero => eDiffZero, mDiffGZ => mDiffGZ,
			RFBit7 => RFBit7, REgreater63 => REgreater63,
		
			loadA => loadA, loadB => loadB,
			loadFx => loadFx,loadFy => loadFy,
			loadDiff => loadDiff, loadCnt => loadCnt,
			shiftFy => shiftFy, shiftFx => shiftFx,
			selAorCnt => selAorCnt, selBorOne => selBorOne, selExpAorB => selExpAorB,
			loadERes => loadERes, loadMRes => loadMRes,
			loadResExp => loadResExp, loadResMant => loadResMant,
			shiftResMant => shiftResMant,
			vectOrAdd1 => vectOrAdd1,
			invertCnt => invertCnt

		);
		

		overflow <= REgreater63;
	
END struct;