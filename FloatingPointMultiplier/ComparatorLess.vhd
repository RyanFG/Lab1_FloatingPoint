LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_misc.all;

ENTITY ComparatorLess IS
	PORT(	x: IN STD_LOGIC_VECTOR(15 downto 0);
			Greater127, LessN126: OUT STD_LOGIC
	);
END ComparatorLess;

ARCHITECTURE struct OF ComparatorLess IS
	
BEGIN	
	Greater127 <= (and_reduce(x(14 downto 8)) and not (x(15)));
	LessN126 <= (and_reduce (x(14 downto 8))and x(15));
END struct;