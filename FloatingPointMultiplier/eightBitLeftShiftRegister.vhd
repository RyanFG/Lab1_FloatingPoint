library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY eightBitLeftShiftRegister IS
	PORT(
		i_resetBar, i_load, i_shift: IN STD_LOGIC;
		i_clock: IN STD_LOGIC;
		i_value: IN STD_LOGIC;
		in_values:IN STD_LOGIC_VECTOR(7 downto 0);
		o_Value: OUT STD_LOGIC;
		o_vector: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END eightBitLeftShiftRegister;

ARCHITECTURE rtl OF eightBitLeftShiftRegister IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(7 downto 0);
	
	COMPONENT newDFF
		PORT(	resetBar: IN STD_LOGIC;
				d: IN STD_LOGIC;
				enable: IN STD_LOGIC;
				clock: IN STD_LOGIC;
				q, qBar: OUT STD_LOGIC
		);
	END COMPONENT;

BEGIN

msb : newDFF
		PORT MAP (	resetBar => i_resetBar,
					d => ((int_Value(6))and(i_shift))or((in_values(7))and(not(i_shift))),
					enable => i_load,
					clock => i_clock,
					q => int_Value(7),
					qBar => int_notValue(7));
						
sixsb	: newDFF
		PORT MAP (	resetBar => i_resetBar,
					d => ((int_Value(5))and(i_shift))or((in_values(6))and(not(i_shift))),
					enable => i_load,
					clock => i_clock,
					q => int_Value(6),
					qBar => int_notValue(6));

fivesb	: newDFF
		PORT MAP (	resetBar => i_resetBar,
					d => ((int_Value(4))and(i_shift))or((in_values(5))and(not(i_shift))),
					enable => i_load,
					clock => i_clock,
					q => int_Value(5),
					qBar => int_notValue(5));


foursb	: newDFF
		PORT MAP (	resetBar => i_resetBar,
					d => ((int_Value(3))and(i_shift))or((in_values(4))and(not(i_shift))),
					enable => i_load,
					clock => i_clock,
					q => int_Value(4),
					qBar => int_notValue(4));
					
threesb	: newDFF
		PORT MAP (	resetBar => i_resetBar,
					d => ((int_Value(2))and(i_shift))or((in_values(3))and(not(i_shift))),
					enable => i_load,
					clock => i_clock,
					q => int_Value(3),
					qBar => int_notValue(3));
						
twosb	: newDFF
		PORT MAP (	resetBar => i_resetBar,
					d => ((int_Value(1))and(i_shift))or((in_values(2))and(not(i_shift))),
					enable => i_load,
					clock => i_clock,
					q => int_Value(2),
					qBar => int_notValue(2));
						
onesb	: newDFF
		PORT MAP (	resetBar => i_resetBar,
					d => ((int_Value(0))and(i_shift))or((in_values(1))and(not(i_shift))),
					enable => i_load,
					clock => i_clock,
					q => int_Value(1),
					qBar => int_notValue(1));
						
lsb	: newDFF
		PORT MAP (	resetBar => i_resetBar,
					d => ((i_value)and(i_shift))or((in_values(0))and(not(i_shift))),
					enable => i_load,
					clock => i_clock,
					q => int_Value(0),
					qBar => int_notValue(0));
		
		-- Output Driver
		o_vector		<= int_Value;
		
		o_Value		<= int_Value(0);
END rtl;