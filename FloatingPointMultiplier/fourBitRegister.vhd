LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fourBitRegister IS
	PORT(	resetBar, load, clock: IN STD_LOGIC;
			inValues: IN STD_LOGIC_VECTOR(3 downto 0);
			outValues: OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END fourBitRegister;

ARCHITECTURE struct OF fourBitRegister IS
SIGNAL intQ: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL intQNot: STD_LOGIC_VECTOR(3 downto 0);

	COMPONENT newDFF IS
		PORT(	resetBar,clock,enable: IN STD_LOGIC;
				d: IN STD_LOGIC;
				q,qBar: OUT STD_LOGIC
		);
	END COMPONENT;
	
BEGIN

	FF0: newDFF
		PORT MAP(
			resetBar => resetBar, clock => clock, enable => load,
			d => inValues(0),
			q => intQ(0),qBar => intQNot(0)
		);

	FF1: newDFF
		PORT MAP(
			resetBar => resetBar, clock => clock, enable => load,
			d => inValues(1),
			q => intQ(1),qBar => intQNot(1)
		);
	
	FF2: newDFF
		PORT MAP(
			resetBar => resetBar, clock => clock, enable => load,
			d => inValues(2),
			q => intQ(2),qBar => intQNot(2)
		);
	
	FF3: newDFF
		PORT MAP(
			resetBar => resetBar, clock => clock, enable => load,
			d => inValues(3),
			q => intQ(3),qBar => intQNot(3)
		);
		
	outValues <= intQ;
	
END struct;
		