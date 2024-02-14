library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignPath is
    port (
        a,b : in std_logic;
        sign : out std_logic
    );
end SignPath;

architecture rtl of SignPath is
begin
	sign <= a xor b;
end architecture;