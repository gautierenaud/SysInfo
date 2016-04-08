----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:49:25 04/06/2016 
-- Design Name: 
-- Module Name:    UAL - Behavioral 
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

entity UAL is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
           N : out  STD_LOGIC;
           O : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (7 downto 0));
end UAL;

architecture Behavioral of UAL is

	signal calcul : STD_LOGIC_VECTOR (15 downto 0);

begin

	calcul <= "0000000" & ("0" & A) + ("0" & B) when Ctrl_Alu = "001"
				else A * B when Ctrl_Alu = "010"
				else x"00" & (B - A) when Ctrl_Alu = "011" and A < B
				else x"00" & (A - B) when Ctrl_Alu = "011";
				
	Z <= '1' when calcul(7 downto 0) = x"00" else '0';
	C <= calcul(8) when Ctrl_Alu = "001" else '0';
	O <= '1' when Ctrl_Alu = "010" and not(calcul(15 downto 8) = x"00") else '0';
	N <= '1' when Ctrl_Alu = "011" and (A < B) else '0';
	
	S <= calcul(7 downto 0);
	
end Behavioral;

