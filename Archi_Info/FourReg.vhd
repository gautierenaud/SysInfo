library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FourReg is
    Port ( IA : in  STD_LOGIC_VECTOR (7 downto 0);
           IOP : in  STD_LOGIC_VECTOR (7 downto 0);
           IB : in  STD_LOGIC_VECTOR (7 downto 0);
           IC : in  STD_LOGIC_VECTOR (7 downto 0);
           OA : out  STD_LOGIC_VECTOR (7 downto 0);
           OOP : out  STD_LOGIC_VECTOR (7 downto 0);
           OB : out  STD_LOGIC_VECTOR (7 downto 0);
           OC : out  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
			  RST : in STD_LOGIC);
end FourReg;

architecture Behavioral of FourReg is

begin
	
	process (CLK)
	begin
		if CLK = '1' then
			if RST = '1' then
				OA <= x"00";
				OB <= x"00";
				OC <= x"00";
				OOP <= x"00";
			else
				OA <= IA;
				OOP <= IOP;
				OB <= IB;
				OC <= IC;
			end if;
		end if;
	end process;


end Behavioral;

