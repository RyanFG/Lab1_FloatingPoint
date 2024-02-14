LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY FPA_Datapath IS
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
END FPA_Datapath;

ARCHITECTURE struct OF FPA_Datapath IS
SIGNAL resExpPath: STD_LOGIC_VECTOR(6 downto 0);
SIGNAL eDiff,mDiff,resMantPath: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL eDiffGZ, mDiffGZ, eDiffZero, mDiffZero: STD_LOGIC;
	
	COMPONENT exponentDatapath
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
	END COMPONENT;
	
	COMPONENT mantissaDatapath
		PORT(
			reset,clk: IN STD_LOGIC;
			loadFx,loadFy,loadRes: IN STD_LOGIC;
			shiftFx,shiftFy: IN STD_LOGIC;
			aMant,bMant: IN STD_LOGIC_VECTOR(7 downto 0);
			resOut: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT normalization
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

BEGIN
	
	expPath: exponentDatapath
		PORT MAP(
			A => aInExp,B => bInExp,
			reset => reset,clk => clk,
			selExpAOrB => selExpAOrB, selAorCnt => selAorCnt,selBorOne => selBorOne,
			loadA => loadAExp,loadB => loadBExp, invertCnt => invertCnt,
			loadDiff => loadDiff, loadCnt => loadCnt, loadERes => loadERes,
			xGZ => xGZ, yGZ => yGZ,
			regRes => resExpPath, eDiffOut => eDiff
		);
	
	mantPath: mantissaDatapath
		PORT MAP(
			reset => reset, clk => clk,
			loadFx => loadFx, loadFy => loadFy, loadRes => loadMRes,
			shiftFx => shiftFx, shiftFy => shiftFy,
			aMant => aInMant,bMant => bInMant,
			resOut => resMantPath
		);
	
	norm: normalization
		PORT MAP(
			reset => reset, clk => clk,
			resMantVect => resMantPath,
			resExpVect => resExpPath,
			loadResExp => loadResExp, loadResMant => loadResMant,
			shiftResMant => shiftResMant,
			vectOrAdd1 => vectOrAdd1,
			resMantFinal => resMantFinal,
			resExpFinal => resExpFinal,
			normalized => normalized,
			overflow => overflow
		);
		
	addOrSub: eightBitCLA
		PORT MAP(
			a => aInMant, b => bInMant,
			addOrSub => '1',
			carryIn => '0',
			s => mDiff
		);
		
	compare: eightBitComparator
		PORT MAP(	
			x => eDiff,y => mDiff,
			xGreaterZero => eDiffGZ,
			yGZ_US8Bit => mDiffGZ,
			xEqZero => eDiffZero,
			yEqZero_8Bit => mDiffZero
		);
		
		eDiffEqZero <= eDiffZero;
		mantDiffGZ <= mDiffGZ;
		
	resSign <= ((eDiffGZ)and(aSign))or((eDiffZero)and(((mDiffGZ)and(aSign))or((not(mDiffGZ))and(bSign))))or((not(eDiffGZ))and(not(eDiffZero))and(bSign));
	
END struct;