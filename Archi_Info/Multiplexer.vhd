
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Multiplexer is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           S : in  STD_LOGIC;
           Z : out  STD_LOGIC_VECTOR (7 downto 0));
end Multiplexer;

architecture Behavioral of Multiplexer is

begin

	Z <= A when S = '0' else B;

end Behavioral;

