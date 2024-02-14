LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY twoToOneMUX IS
	PORT(	inA: IN STD_LOGIC;
			inB: IN STD_LOGIC;
			sel: IN STD_LOGIC;
			outC: OUT STD_LOGIC
	);
END twoToOneMUX;

ARCHITECTURE struct OF twoToOneMUX IS
SIGNAL a1,a2: STD_LOGIC;

BEGIN

	a1 <= inA and not(sel);
	a2 <= inB and sel;
	
	outC <= a1 or a2;
	
END struct;