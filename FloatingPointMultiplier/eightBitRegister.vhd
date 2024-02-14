LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitRegister IS
	PORT(	resetBar, load, clock: IN STD_LOGIC;
			inValues: IN STD_LOGIC_VECTOR(7 downto 0);
			outValues: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END eightBitRegister;

ARCHITECTURE struct OF eightBitRegister IS

	COMPONENT fourBitRegister
		PORT(	resetBar, load, clock: IN STD_LOGIC;
				inValues: IN STD_LOGIC_VECTOR(3 downto 0);
				outValues: OUT STD_LOGIC_VECTOR(3 downto 0)
		);
	END COMPONENT;
	
BEGIN

	reg1: fourBitRegister
		PORT MAP(
			resetBar => resetBar, load => load, clock => clock,
			inValues => inValues(3 downto 0),
			outValues => outValues(3 downto 0)
		);
	
	reg2: fourBitRegister
		PORT MAP(
			resetBar => resetBar, load => load, clock => clock,
			inValues => inValues(7 downto 4),
			outValues => outValues(7 downto 4)
		);

END struct;