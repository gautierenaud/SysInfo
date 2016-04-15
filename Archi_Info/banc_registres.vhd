----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:02:52 04/06/2016 
-- Design Name: 
-- Module Name:    banc_registres - Behavioral 
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

entity banc_registres is
    Port ( AddrA : in  STD_LOGIC_VECTOR (3 downto 0);
           AddrB : in  STD_LOGIC_VECTOR (3 downto 0);
           AddrW : in  STD_LOGIC_VECTOR (3 downto 0);
           W : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           QA : out  STD_LOGIC_VECTOR (7 downto 0);
           QB : out  STD_LOGIC_VECTOR (7 downto 0));
end banc_registres;

architecture Behavioral of banc_registres is

	type Banc_Registres is array (0 to 15) of STD_LOGIC_VECTOR (7 downto 0);
	signal Reg : Banc_Registres;

begin
	
	QA <= Reg(conv_integer(AddrA));
	QB <= Reg(conv_integer(AddrB));
	
	process (clk)
		begin
		if CLK'event and CLK = '1' then
			if RST = '1' then
				for I in 0 to 15 loop
					Reg(I) <= x"00";
				end loop;
			elsif W = '1' then
				Reg(conv_integer(AddrW)) <= DATA;
			end if;
		end if;
	end process;


end Behavioral;

