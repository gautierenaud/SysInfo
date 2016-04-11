
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity LogicCombi is
    Port ( DIN : in  STD_LOGIC_VECTOR (7 downto 0);
				CLK : in STD_LOGIC;
           DOUT : out  STD_LOGIC);
end LogicCombi;

architecture Behavioral of LogicCombi is

begin

	process(CLK)
	begin
		if CLK = '1' then
			if DIN = x"01" or DIN = x"02" or DIN = x"03" or DIN = x"04" then
				DOUT <= '1';
			else
				DOUT <= '0';
			end if;
		end if;
	end process;

end Behavioral;

