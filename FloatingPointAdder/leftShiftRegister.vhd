LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY leftShiftRegister IS
	PORT(	resetBar, load, clock, shift: IN STD_LOGIC;
			shiftValue: IN STD_LOGIC;
			inValues: IN STD_LOGIC_VECTOR(3 downto 0);
			outValues: OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END leftShiftRegister;

ARCHITECTURE struct OF leftShiftRegister IS
SIGNAL intQ,intQNot: STD_LOGIC_VECTOR(3 downto 0);

	COMPONENT newDFF IS
		PORT(	resetBar,clock,enable: IN STD_LOGIC;
				d: IN STD_LOGIC;
				q,qBar: OUT STD_LOGIC
		);
	END COMPONENT;
	
BEGIN

	FF0: newDFF
		PORT MAP(
			resetBar => resetBar, clock => clock, enable => shift,
			d => shiftValue,
			q => intQ(0),qBar => intQNot(0)
		);

	FF1: newDFF
		PORT MAP(
			resetBar => resetBar, clock => clock, enable => shift,
			d => intQ(0),
			q => intQ(1),qBar => intQNot(1)
		);
	
	FF2: newDFF
		PORT MAP(
			resetBar => resetBar, clock => clock, enable => shift,
			d => intQ(1),
			q => intQ(2),qBar => intQNot(2)
		);
	
	FF3: newDFF
		PORT MAP(
			resetBar => resetBar, clock => clock, enable => shift,
			d => intQ(2),
			q => intQ(3),qBar => intQNot(3)
		);
		
	outValues(0) <= load and intQ(0);
	outValues(1) <= load and intQ(1);
	outValues(2) <= load and intQ(2);
	outValues(3) <= load and intQ(3);
	
END struct;
		
