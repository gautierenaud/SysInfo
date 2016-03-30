
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity compteur is
    Port ( ck : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           load : in  STD_LOGIC;
           sens : in  STD_LOGIC;
           en : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (7 downto 0);
           dout : out  STD_LOGIC_VECTOR (7 downto 0));
end compteur;

architecture Behavioral of compteur is

	signal aux : STD_LOGIC_VECTOR (7 downto 0);
	
begin

process
	begin
		wait until ck'event and ck='1';
		if rst='0' then aux <= X"00";
		else
		if load='1' then aux <= din;
		else
			if en='0' then
				if sens='1' then aux <= aux + 1;
				elsif sens='0' then aux <= aux -1;
				end if; 
			end if;
		end if;
		end if;
end process;

dout <= aux;




end Behavioral;

