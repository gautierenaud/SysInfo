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
	signal test : STD_LOGIC_VECTOR (8 downto 0);

begin

	S <= A + B when Ctrl_Alu = "001";
	test <= ("0" & A) + ("0" & B) when Ctrl_Alu = "001";
	C <= test(8) when Ctrl_Alu = "001";
	
			--else A * B when Ctrl_ALu = "010";

--
--	calcul <= X"00" & (A + B) when Ctrl_Alu = x"01"
--			else A * B when Ctrl_Alu = x"02"
--			else A - B when Ctrl_Alu = x"03"
--			else (others => '0');
--	
--	calcul <= x"0111";
--
--	Z <= '1' when calcul = x"00" else '0';
--	N <= '1' when(calcul < x"00") else '0';
--	C <= '1' when(calcul > x"FF" and Ctrl_Alu = x"01") else '0';
--	O <= '1' when(calcul > x"FF" and Ctrl_Alu = x"02")else '0';
--
--
	Z <= '1';
end Behavioral;

