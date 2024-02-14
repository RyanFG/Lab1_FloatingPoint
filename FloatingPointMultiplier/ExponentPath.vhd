library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ExponentPath is
    port (
        clock : in std_logic;
        loadRE,loadAE,loadBE : in std_logic;
		  carryOut : out std_logic;
        Ex,Ey :in std_logic_vector (6 downto 0);
        Addexpby : in std_logic_vector (2 downto 0);
        resetBar: in std_logic;
		  iRE_eqZ: OUT STD_LOGIC;
        o_RE : out std_logic_vector (6 downto 0)		  
    );
end ExponentPath;

architecture rtl of ExponentPath is
 signal i_RE1, i_RE2, AE ,BE : std_logic_vector (7 downto 0);

 
	component eightbitregister is
		port (
			resetBar, load, clock: IN STD_LOGIC;
			inValues: IN STD_LOGIC_VECTOR(7 downto 0);
			outValues: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
 
	component eightBitCLA is
		port (
			a,b: IN STD_LOGIC_VECTOR(7 downto 0);
			addOrSub: IN STD_LOGIC;
			carryIn: IN STD_LOGIC;
			s: OUT STD_LOGIC_VECTOR(7 downto 0);
			carryOut: OUT STD_LOGIC
		  );
	end component;
	
	Component eightBitComparator Is
		PORT(	
			x,y: IN STD_LOGIC_VECTOR(7 downto 0);
			eq: OUT STD_LOGIC;
			xGreaterZero: OUT STD_LOGIC;
			yGreaterZero: OUT STD_LOGIC;
			bitX7Eq1: OUT STD_LOGIC;
			bitY7Eq1: OUT STD_LOGIC;
			xEqZero, yEqZero: OUT STD_LOGIC;
			xGZ_US8Bit, yGZ_US8Bit: OUT STD_LOGIC;
			xEqZero_8Bit, yEqZero_8Bit: OUT STD_LOGIC
		);
	END Component;

begin

	eightbitregister_inst0: eightBitRegister
		port map (
		  resetBar  => resetBar,
		  load      => loadAE,
		  clock     => clock,
		  inValues (6 downto 0)  => Ex (6 downto 0),
		  inValues (7) => '0',
		  outValues => AE
		);
		 
	eightbitregister_inst1: eightBitRegister
		port map (
		  resetBar  => resetBar,
		  load      => loadBE,
		  clock     => clock,
		  inValues (6 downto 0)  => Ey (6 downto 0),
		  inValues (7) => '0',
		  outValues => BE
		);

	eightbitcla_inst0: eightBitCLA
		port map (
		  a        => AE,
		  b        => BE,
		  addOrSub => '0',
		  carryIn  => '0',
		  s        => i_RE1,
		  carryOut => carryOut
		);

	eightbitcla_inst1: eightBitCLA
		port map (
		  a        => i_RE1,
		  b        => "00111111",
		  addOrSub => '1',
		  carryIn  => '0',
		  s        => i_RE2
		);

	eightbitregister_inst2: eightBitRegister
		port map (
		  resetBar  => resetBar,
		  load      => loadRE,
		  clock     => clock,
		  inValues  => i_RE1,
		  outValues (6 downto 0) => o_RE (6 downto 0)
		);
	
	compare: eightBitComparator
		PORT MAP(
			x => i_RE2,y => "00000000",
			xEqZero_8Bit => iRE_eqZ
		);
		
end architecture;