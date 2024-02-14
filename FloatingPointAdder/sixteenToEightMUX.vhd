LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sixteenToEightMUX IS
	PORT(	inA: IN STD_LOGIC_VECTOR(7 downto 0);
			inB: IN STD_LOGIC_VECTOR(7 downto 0);
			sel: IN STD_LOGIC;
			outC: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END sixteenToEightMUX;

ARCHITECTURE struct OF sixteenToEightMUX IS

	COMPONENT twoToOneMUX
		PORT(	inA: IN STD_LOGIC;
				inB: IN STD_LOGIC;
				sel: IN STD_LOGIC;
				outC: OUT STD_LOGIC
		);
	END COMPONENT;	

BEGIN

	mux1: twoToOneMUX
		PORT MAP(
			inA => inA(0),
			inB => inB(0),
			sel => sel,
			outC => outC(0)
		);
		
	mux2: twoToOneMUX
		PORT MAP(
			inA => inA(1),
			inB => inB(1),
			sel => sel,
			outC => outC(1)
		);
		
	mux3: twoToOneMUX
		PORT MAP(
			inA => inA(2),
			inB => inB(2),
			sel => sel,
			outC => outC(2)
		);
		
	mux4: twoToOneMUX
		PORT MAP(
			inA => inA(3),
			inB => inB(3),
			sel => sel,
			outC => outC(3)
		);
		
	mux5: twoToOneMUX
	PORT MAP(
			inA => inA(4),
			inB => inB(4),
			sel => sel,
			outC => outC(4)
		);
		
	mux6: twoToOneMUX
		PORT MAP(
			inA => inA(5),
			inB => inB(5),
			sel => sel,
			outC => outC(5)
		);
		
	mux7: twoToOneMUX
		PORT MAP(
			inA => inA(6),
			inB => inB(6),
			sel => sel,
			outC => outC(6)
		);
		
	mux8: twoToOneMUX
		PORT MAP(
			inA => inA(7),
			inB => inB(7),
			sel => sel,
			outC => outC(7)
		);

END struct;