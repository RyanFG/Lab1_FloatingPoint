library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MuliplierPath is
    port (
        clk : in std_logic;
        loadAM, loadBM, loadRM, ShiftLRM, ShiftRRM, i_resetBar : in std_logic;
        Fx, Fy : in std_logic_vector (7 downto 0);
		  mantOut: OUT STD_LOGIC_VECTOR(7 downto 0);
        Cout, greater127, lessN126 : out std_logic;
        loadRE,loadAE,loadBE, SignA, SignB: in std_logic;
		  Sign : OUT std_logic;
		  carryOut : out std_logic;
        Ex,Ey :in std_logic_vector (6 downto 0);
		  overflow: OUT STD_LOGIC;
        o_RE : out std_logic_vector (6 downto 0) 
    );
end MuliplierPath;

architecture rtl of MuliplierPath is
    signal shiftexp : std_LOGIC_VECTOR(2 downto 0);
	 SIGNAL iRE_eqZ: STD_LOGIC;

    component MantissaPath is
		 port (
			clk : in std_logic;
			loadAM, loadBM, loadRM, ShiftLRM, ShiftRRM, i_resetBar : in std_logic;
			Fx, Fy : in std_logic_vector (7 downto 0);
			Cout, greater127, lessN126: out std_logic;
			NumShift: out std_logic_VECTOR(2 downto 0);
			Res : out std_logic_vector (7 downto 0)
		 );
    end component;

    component ExponentPath is
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
    end component;

    component SignPath is
        port (
            a,b : in std_logic;
            sign : out std_logic
        );
    end component;
    

begin
	mantPath: MantissaPath
		port map (
		  clk        => clk,
		  loadAM     => loadAM,
		  loadBM     => loadBM,
		  loadRM     => loadRM,
		  ShiftLRM   => ShiftLRM,
		  ShiftRRM  => ShiftRRM,
		  i_resetBar => i_resetBar,
		  Fx         => Fx,
		  Fy         => Fy,
		  Numshift   => shiftexp,
		  Cout       => Cout,
		  greater127 => greater127,
		  lessN126   => lessN126,
		  Res			 => mantOut
		);

	expPath: ExponentPath
		port map (
		  clock      => clk,
		  loadRE   => loadRE,
		  loadAE   => loadAE,
		  loadBE   => loadBE,
		  carryOut => carryOut,
		  Ex       => Ex,
		  Ey       => Ey,
		  Addexpby => shiftexp,
		  resetBar => i_resetBar,
		  iRE_eqZ	=> iRE_eqZ,
		  o_RE     => o_RE
		);

	sPath: SignPath
		port map (
		  a    => SignA,
		  b    => SignB,
		  sign => Sign
		);
		
	overflow <= (iRE_eqZ);
end architecture;