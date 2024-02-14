LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY controlPath IS
	PORT(
		reset,clk: IN STD_LOGIC;
		greater127,lessN126: IN STD_LOGIC;
	
		loadAM,loadAE,loadBM,loadBE: OUT STD_LOGIC;
		loadRE,loadRM,loadRS: OUT STD_LOGIC;
		shiftRRM,shiftLRM: OUT STD_LOGIC
	);
END controlPath;

ARCHITECTURE struct OF controlPath IS
SIGNAL s: STD_LOGIC_VECTOR(5 downto 0);

	COMPONENT newDFF IS
		PORT(
			resetBar	: IN	STD_LOGIC;
			d		: IN	STD_LOGIC;
			enable	: IN	STD_LOGIC;
			clock		: IN	STD_LOGIC;
			q, qBar	: OUT	STD_LOGIC
		);
	END COMPONENT;

BEGIN

	FF1: newDFF
		PORT MAP(
			resetBar => not(reset),
			d => not((s(1))or(s(2))or(s(3))or(s(4))or(s(5))),
			enable => '1',
			clock => clk,
			q => s(0)
		);
	
	FF2: newDFF
		PORT MAP(
			resetBar => not(reset),
			d => s(0),
			enable => '1',
			clock => clk,
			q => s(1)
		);
	
	FF3: newDFF
		PORT MAP(
			resetBar => not(reset),
			d => s(1),
			enable => '1',
			clock => clk,
			q => s(2)
		);
	
	FF4: newDFF
		PORT MAP(
			resetBar => not(reset),
			d => ((s(2))and(greater127))or(((s(3))or(s(4)))and(greater127)),
			enable => '1',
			clock => clk,
			q => s(3)
		);
	
	FF5: newDFF
		PORT MAP(
			resetBar => not(reset),
			d => ((s(2))and(lessN126))or(((s(3))or(s(4)))and(lessN126)),
			enable => '1',
			clock => clk,
			q => s(4)
		);
		
	FF6: newDFF
		PORT MAP(
			resetBar => not(reset),
			d => (((s(2))or(s(3))or(s(4)))and(not(lessN126))and(not(greater127))),
			enable => '1',
			clock => clk,
			q => s(5)
		);
		
	loadAM <= s(0);
	loadAE <= s(0);
	loadBM <= s(0);
	loadBE <= s(0);
	
	loadRE <= '1';
	
	loadRM <= (s(2))or(s(3))or(s(4));
	
	shiftRRM <= s(3);
	
	shiftLRM <= s(4);
	
	loadRS <= s(5);
	

END struct;