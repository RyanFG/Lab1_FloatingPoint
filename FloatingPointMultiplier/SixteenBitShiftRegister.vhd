library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SixteenBitShiftRegister is
    port (
        i_resetBar, i_load, i_clock, i_value: in std_logic;
        i_shift : in std_logic_vector (15 downto 0);
        ShiftLeftRM, ShiftRightRM : in std_logic;
        o_Shift : out std_logic_vector (15 downto 0)

    );
end SixteenBitShiftRegister;

architecture rtl of SixteenBitShiftRegister is
signal o_ValuesSplit1, o_ValuesSplit2 : std_logic_vector (7 downto 0); 
signal o_ValueCarry, o_Value : std_logic; 

component eightBitLeftShiftRegister is
PORT(
		i_resetBar, i_load, i_shift: IN STD_LOGIC;
		i_clock: IN STD_LOGIC;
		i_value: IN STD_LOGIC;
		in_values:IN STD_LOGIC_VECTOR(7 downto 0);
		o_Value: OUT STD_LOGIC;
		o_vector: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
end component;

component eightBitRightShiftRegister is
    PORT(
            i_resetBar, i_load, i_shift: IN STD_LOGIC;
            i_clock: IN STD_LOGIC;
            i_value: IN STD_LOGIC;
            in_values:IN STD_LOGIC_VECTOR(7 downto 0);
            o_Value: OUT STD_LOGIC;
            o_vector: OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    begin
        
        eightbitleftshiftregister_inst1: eightBitLeftShiftRegister
        port map (
          i_resetBar => i_resetBar,
          i_load     => i_load,
          i_shift    => ShiftLeftRM,
          i_clock    => i_clock,
          i_value    => i_value,
          in_values  => i_shift (7 downto 0),
          o_Value    => o_ValueCarry,
          o_vector   => o_ValuesSplit1
        );
        
        eightbitleftshiftregister_inst2: eightBitLeftShiftRegister
        port map (
          i_resetBar => i_resetBar,
          i_load     => i_load,
          i_shift    => ShiftLeftRM,
          i_clock    => i_clock,
          i_value    => o_ValueCarry,
          in_values  => i_shift (15 downto 8),
          o_Value    => o_Value,
          o_vector   => o_ValuesSplit2
        );

        eightbitrightshiftregister_inst1: eightBitLeftShiftRegister
        port map (
          i_resetBar => i_resetBar,
          i_load     => i_load,
          i_shift    => ShiftRightRM,
          i_clock    => i_clock,
          i_value    => i_value,
          in_values  => i_shift (7 downto 0),
          o_Value    => o_ValueCarry,
          o_vector   => o_ValuesSplit1
        );
        
        eightbitrightshiftregister_inst2: eightBitLeftShiftRegister
        port map (
          i_resetBar => i_resetBar,
          i_load     => i_load,
          i_shift    => ShiftRightRM,
          i_clock    => i_clock,
          i_value    => o_ValueCarry,
          in_values  => i_shift (15 downto 8),
          o_Value    => o_Value,
          o_vector   => o_ValuesSplit2
        );

        o_Shift (0) <= o_ValuesSplit1 (0); 
        o_Shift (1) <= o_ValuesSplit1 (1);
        o_Shift (2) <= o_ValuesSplit1 (2); 
        o_Shift (3) <= o_ValuesSplit1 (3); 
        o_Shift (4) <= o_ValuesSplit1 (4); 
        o_Shift (5) <= o_ValuesSplit1 (5); 
        o_Shift (6) <= o_ValuesSplit1 (6); 
        o_Shift (7) <= o_ValuesSplit1 (7); 
        o_Shift (8) <= o_ValuesSplit2 (0); 
        o_Shift (9) <= o_ValuesSplit2 (1); 
        o_Shift (10) <= o_ValuesSplit2(2);
        o_Shift (11) <= o_ValuesSplit2(3);
        o_Shift (12) <= o_ValuesSplit2(4);
        o_Shift (13) <= o_ValuesSplit2(5);
        o_Shift (14) <= o_ValuesSplit2(6);
        o_Shift (15) <= o_ValuesSplit2(7);


        

end architecture;