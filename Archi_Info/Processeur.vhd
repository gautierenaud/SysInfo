
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Processeur is
    Port ( Clk : in STD_LOGIC;
			  RST : in STD_LOGIC;
           SA : out STD_LOGIC_VECTOR (7 downto 0);
           SB : out STD_LOGIC_VECTOR (7 downto 0) );
end Processeur;

architecture Behavioral of Processeur is

	 COMPONENT banc_registres
	 PORT(
			AddrA : IN  std_logic_vector(7 downto 0);
			AddrB : IN  std_logic_vector(7 downto 0);
			AddrW : IN  std_logic_vector(7 downto 0);
			W : IN  std_logic;
			DATA : IN  std_logic_vector(7 downto 0);
			RST : IN  std_logic;
			CLK : IN  std_logic;
			QA : OUT  std_logic_vector(7 downto 0);
			QB : OUT  std_logic_vector(7 downto 0)
		  );
	 END COMPONENT;
	 
	 COMPONENT UAL
	 PORT(
			A : IN  std_logic_vector(7 downto 0);
			B : IN  std_logic_vector(7 downto 0);
			Ctrl_Alu : IN  std_logic_vector(2 downto 0);
			N : OUT  std_logic;
			O : OUT  std_logic;
			Z : OUT  std_logic;
			C : OUT  std_logic;
			S : OUT  std_logic_vector(7 downto 0)
		  );
	 END COMPONENT;
	 
	 
	 
	 COMPONENT Mem_Instructions
		 PORT(
			CLK : IN std_logic;
			Address : IN std_logic_vector(15 downto 0);       
			Dout : OUT std_logic_vector(31 downto 0)
			);
	 END COMPONENT;
			 
	 COMPONENT memData
	 PORT(
			adr : IN  std_logic_vector(15 downto 0);
			din : IN  std_logic_vector(7 downto 0);
			rw : IN  std_logic;
			rst : IN  std_logic;
			clk : IN  std_logic;
			dout : OUT  std_logic_vector(7 downto 0)
		  );
	 END COMPONENT;

begin

process
	begin
		wait until ck'event and ck='1';
end process;

end Behavioral;

