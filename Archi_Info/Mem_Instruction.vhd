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

entity Mem_Instructions is
    Port ( Address : in  STD_LOGIC_VECTOR (15 downto 0);
           CLK : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end Mem_Instructions;

	architecture Behavioral of Mem_Instructions is
	
	type ROM_INSTRUCTIONS is array (0 to (60)) of STD_LOGIC_VECTOR (31 downto 0);
	--type ROM_INSTRUCTIONS is array (0 to (2**16 - 1)) of STD_LOGIC_VECTOR (31 downto 0);
	signal ROM : ROM_INSTRUCTIONS := ((x"06010802"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"05050101"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"01020105"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"02030105"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"03040105"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"08100300"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"07001000"), others => x"00000000");
	
begin

	process
		begin
		wait until clk'event and clk='1';
		Dout <= ROM(conv_integer(Address));
	end process;
	
end Behavioral;

