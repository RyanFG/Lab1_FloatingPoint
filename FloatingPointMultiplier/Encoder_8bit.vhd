LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_misc.ALL;

entity encoder_8Bits is
    port(
        inp : in std_logic_vector(7 downto 0);
        outp : out std_logic_vector(2 downto 0));
end encoder_8Bits;

architecture rtl of encoder_8Bits is

-- component
        
-- wires 
signal masks : std_logic_vector(7 downto 0);

begin
    
    loop0: for i in 0 to 7 generate
        masks(i) <= nor_reduce(inp(7 downto i+1)) and inp(i);    --if everyone to the left is 0 and I am 1. it's me.
    end generate;
    
    
    outp <=  ("000" and ((outp'range) => masks(0))) or 
                ("001" and ((outp'range) => masks(1))) or 
                ("010" and ((outp'range) => masks(2))) or 
                ("011" and ((outp'range) => masks(3))) or 
                ("100" and ((outp'range) => masks(4))) or 
                ("101" and ((outp'range) => masks(5))) or 
                ("110" and ((outp'range) => masks(6))) or 
                ("111" and ((outp'range) => masks(7)));

end rtl;