library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_misc.all;

entity MantissaPath is
    port (
		clk : in std_logic;
		loadAM, loadBM, loadRM, ShiftLRM, ShiftRRM, i_resetBar : in std_logic;
		Fx, Fy : in std_logic_vector (7 downto 0);
		Cout, greater127, lessN126: out std_logic;
		NumShift: out std_logic_VECTOR(2 downto 0);
		Res : out std_logic_vector (7 downto 0)
    );
end MantissaPath;

architecture rtl of MantissaPath is

signal AM, BM : std_LOGIC_VECTOR (7 downto 0);
signal RM, o_RM : std_LOGIC_VECTOR (15 downto 0);
signal ShiftBy, ShiftByOrig : std_logic_vector (2 downto 0);

	component eightBitRegister is
		PORT(	resetBar, load, clock: IN STD_LOGIC;
					inValues: IN STD_LOGIC_VECTOR(7 downto 0);
					outValues: OUT STD_LOGIC_VECTOR(7 downto 0)
			);
	end component;

	component ClassicMultiplier is
		Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
					  B : in  STD_LOGIC_VECTOR (7 downto 0);
					  P : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;

	component SixteenBitShiftRegister is
		 port (
			  i_resetBar, i_load, i_clock, i_value: in std_logic;
			  i_shift : in std_logic_vector (15 downto 0);
			  ShiftLeftRM, ShiftRightRM: in std_logic;
			  o_Shift : out std_logic_vector (15 downto 0)

		 );
	end component;
    
	component ComparatorLess is
		 PORT(	x: IN STD_LOGIC_VECTOR(15 downto 0);
				Greater127, LessN126: OUT STD_LOGIC
		);
	end component;

	component encoder_8Bits is
		port(
			inp : in std_logic_vector(7 downto 0);
			outp : out std_logic_vector(2 downto 0));
	end component;


begin
		


	eightBitRegisterFx: eightBitRegister
		PORT MAP(
			resetBar => i_resetBar, 
			load => loadAM, 
			clock => clk,
			inValues => Fx,
			outValues => AM
		);
		
	eightBitRegisterFy: eightBitRegister
		PORT MAP(
			resetBar => i_resetBar, 
			load => loadBM, 
			clock => clk,
			inValues => Fy,
			outValues => BM
		);
		
	ClassicMultiplier1_inst : ClassicMultiplier
		PORT MAP(
			A => AM,
			B => BM,
			P => RM
		);
		
	comparatorless_inst: ComparatorLess
		port map (
			x          => RM,
			Greater127 => Greater127,
			LessN126   => LessN126
		);
	
	SixteenBitShiftRegister_inst: SixteenBitShiftRegister
		PORT MAP(
			  i_resetBar => i_resetBar, i_load => loadRM, i_clock => clk, i_value => '0',
			  i_shift => RM, 
			  ShiftLeftRM => ShiftLRM, ShiftRightRM => ShiftRRM, 
			  o_Shift =>  o_RM
		);

	NumShift <= ShiftByOrig;
	Res <= RM (7 downto 0);
		
end architecture;