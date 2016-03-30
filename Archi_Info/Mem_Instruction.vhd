----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:17:03 03/30/2016 
-- Design Name: 
-- Module Name:    Mem_Instructions - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
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
	
	type ROM_INSTRUCTIONS is array (0 to (2**16 - 1)) of STD_LOGIC_VECTOR (31 downto 0);
	signal ROM : ROM_INSTRUCTIONS;
	
begin

	process
		begin
			if rising_edge(CLK) then
				Dout <= ROM(conv_integer(Address));
			end if;
	end process;
	
end Behavioral;

