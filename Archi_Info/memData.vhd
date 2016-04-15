
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

entity memData is
    Port ( adr : in  STD_LOGIC_VECTOR (7 downto 0);
           din : in  STD_LOGIC_VECTOR (7 downto 0);
           rw : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           dout : out  STD_LOGIC_VECTOR (7 downto 0));
end memData;

architecture Behavioral of memData is
	type MEMOIRE is array (0 to (2**8 - 1)) of STD_LOGIC_VECTOR (7 downto 0);
	signal mem : MEMOIRE;

begin

process
begin
	wait until clk'event and clk='1';
	if rst='1' then  mem <= (others => (others => '0'));	
	else
		if rw='1' then
			mem(conv_integer(adr)) <= din;
		end if;
	end if;
		
end process;

dout <= mem(conv_integer(adr));

end Behavioral;

