LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY FPMultiplier IS
	PORT(
		reset,clk: IN STD_LOGIC;
		mantAIn: IN STD_LOGIC_VECTOR(7 downto 0);
		expAin: IN STD_LOGIC_VECTOR(6 downto 0);
		signA: IN STD_LOGIC;
		
		signO: OUT STD_LOGIC;
		mantOut: OUT STD_LOGIC_VECTOR(7 downto 0);
		expOut: OUT STD_LOGIC_VECTOR(6 downto 0);
		overflow: OUT STD_LOGIC
	);
END FPMultiplier;

ARCHITECTURE struct OF FPMultiplier IS
SIGNAL loadAM,loadAE,loadBM,loadBE: STD_LOGIC;
SIGNAL loadRE,loadRM,loadRS: STD_LOGIC;
SIGNAL shiftRRM,shiftLRM: STD_LOGIC;
SIGNAL greater127,lessN126: STD_LOGIC;
SIGNAL mantBIn: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL expBin: STD_LOGIC_VECTOR(6 downto 0);
SIGNAL signB: STD_LOGIC;

	COMPONENT muliplierPath IS
		port (
        clk : in std_logic;
        loadAM, loadBM, loadRM, ShiftLRM, ShiftRRM, i_resetBar : in std_logic;
        Fx, Fy : in std_logic_vector (7 downto 0);
		  mantOut: OUT STD_LOGIC_VECTOR(7 downto 0);
        Cout, greater127, lessN126 : out std_logic;
        loadRE,loadAE,loadBE, SignA, SignB: in std_logic;
		  Sign : OUT std_logic;
		  carryOut: OUT STD_LOGIC;
        Ex,Ey :in std_logic_vector (6 downto 0);
		  overflow: OUT STD_LOGIC;
        o_RE : out std_logic_vector (6 downto 0) 
    );
	END COMPONENT;
	
	COMPONENT controlPath IS
		PORT(
			reset,clk: IN STD_LOGIC;
			greater127,lessN126: IN STD_LOGIC;
		
			loadAM,loadAE,loadBM,loadBE: OUT STD_LOGIC;
			loadRE,loadRM,loadRS: OUT STD_LOGIC;
			shiftRRM,shiftLRM: OUT STD_LOGIC
		);
	END COMPONENT;

BEGIN
	
	mantBIn <= "00000001";
	expBin <= "0000001";
	signB <= '0';
	
	muliplier: muliplierPath
		PORT MAP(
			  clk        => clk,
			  loadAM     => loadAM,
			  loadBM     => loadBM,
			  loadRM     => loadRM,
			  ShiftLRM   => ShiftLRM,
			  ShiftRRM  => ShiftRRM,
			  i_resetBar => not(reset),
			  Fx         => mantAIn,
			  Fy         => mantBIn,
			  greater127 => greater127,
			  lessN126   => lessN126,
			  mantOut	=> mantOut,
			  loadRE   => loadRE,
			  loadAE   => loadAE,
			  loadBE   => loadBE,
			  Ex       => expAin,
			  Ey       => expBin,
			  overflow => overflow,
			  signA    => SignA,
			  signB    => SignB,
			  Sign 		=> signO
		);
	
	control: controlPath
		PORT MAP(
			reset => reset,clk => clk,
			greater127 => greater127, lessN126 => lessN126,
		
			loadAM => loadAM,loadAE => loadAE, loadBM => loadBM, loadBE => loadBE,
			loadRE => loadRE, loadRM => loadRM, loadRS => loadRS,
			shiftRRM => shiftRRM, shiftLRM => shiftLRM
	);
	

END struct;