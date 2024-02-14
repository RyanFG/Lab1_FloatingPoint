LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY firstOne IS
	PORT(
		A: IN STD_LOGIC_VECTOR(7 downto 0);
		one: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END firstOne;

ARCHITECTURE struct OF firstOne IS
	SIGNAL i: STD_LOGIC_VECTOR(7 downto 0);

BEGIN
	
	i(0) <= (A(0));
	i(1) <= (A(1))and(not(i(0)));
	i(2) <= (A(2))and(not(i(0)))and(not(i(1)));
	i(3) <= (A(3))and(not(i(0)))and(not(i(1)))and(not(i(2)));
	i(4) <= (A(4))and(not(i(0)))and(not(i(1)))and(not(i(2)))and(not(i(3)));
	i(5) <= (A(5))and(not(i(0)))and(not(i(1)))and(not(i(2)))and(not(i(3)))and(not(i(4)));
	i(6) <= (A(6))and(not(i(0)))and(not(i(1)))and(not(i(2)))and(not(i(3)))and(not(i(4)))and(not(i(5)));
	i(7) <= (A(6))and(not(i(0)))and(not(i(1)))and(not(i(2)))and(not(i(3)))and(not(i(4)))and(not(i(5)))and(not(i(6)));
	
	one(0) <= (i(0))or(i(1))or(i(2))or(i(3))or(i(4))or(i(5))or(i(6))or(i(7));
	one(1) <= (i(1))or(i(2))or(i(3))or(i(4))or(i(5))or(i(6))or(i(7));
	one(2) <= (i(2))or(i(3))or(i(4))or(i(5))or(i(6))or(i(7));
	one(3) <= (i(3))or(i(4))or(i(5))or(i(6))or(i(7));
	one(4) <= (i(4))or(i(5))or(i(6))or(i(7));
	one(5) <= (i(5))or(i(6))or(i(7));
	one(6) <= (i(6))or(i(7));
	one(7) <= i(7);
	
END struct;