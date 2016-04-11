
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

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
	 
	 COMPONENT FourReg PORT (
			  IA : in  STD_LOGIC_VECTOR (7 downto 0);
           IOP : in  STD_LOGIC_VECTOR (7 downto 0);
           IB : in  STD_LOGIC_VECTOR (7 downto 0);
           IC : in  STD_LOGIC_VECTOR (7 downto 0);
           OA : out  STD_LOGIC_VECTOR (7 downto 0);
           OOP : out  STD_LOGIC_VECTOR (7 downto 0);
           OB : out  STD_LOGIC_VECTOR (7 downto 0);
           OC : out  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
			  RST : in STD_LOGIC);
	END COMPONENT;
	
		 COMPONENT ThreeReg PORT (
			  IA : in  STD_LOGIC_VECTOR (7 downto 0);
           IOP : in  STD_LOGIC_VECTOR (7 downto 0);
           IB : in  STD_LOGIC_VECTOR (7 downto 0);
           OA : out  STD_LOGIC_VECTOR (7 downto 0);
           OOP : out  STD_LOGIC_VECTOR (7 downto 0);
           OB : out  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
			  RST : in STD_LOGIC);
	END COMPONENT;
	
	COMPONENT LogicCombi PORT (
           DIN : in  STD_LOGIC_VECTOR (7 downto 0);
			  CLK : in STD_LOGIC;
           DOUT : out  STD_LOGIC);
	END COMPONENT;
			
signal CK : std_logic := '0';
signal memInstructOut : std_logic_vector (31 downto 0) := (others => '0');
signal A0 : std_logic_vector (7 downto 0) := (others => '0');
signal A1 : std_logic_vector (7 downto 0) := (others => '0');
signal A2 : std_logic_vector (7 downto 0) := (others => '0');
signal A3 : std_logic_vector (7 downto 0) := (others => '0');
signal A4 : std_logic_vector (7 downto 0) := (others => '0');
signal OP0 : std_logic_vector (7 downto 0) := (others => '0');
signal OP1 : std_logic_vector (7 downto 0) := (others => '0');
signal OP2 : std_logic_vector (7 downto 0) := (others => '0');
signal OP3 : std_logic_vector (7 downto 0) := (others => '0');
signal OP4 : std_logic_vector (7 downto 0) := (others => '0');
signal B0 : std_logic_vector (7 downto 0) := (others => '0');
signal B1 : std_logic_vector (7 downto 0) := (others => '0');
signal B2 : std_logic_vector (7 downto 0) := (others => '0');
signal B3 : std_logic_vector (7 downto 0) := (others => '0');
signal B4 : std_logic_vector (7 downto 0) := (others => '0');
signal C0 : std_logic_vector (7 downto 0) := (others => '0');
signal C1 : std_logic_vector (7 downto 0) := (others => '0');
signal C2 : std_logic_vector (7 downto 0) := (others => '0');
signal C3 : std_logic_vector (7 downto 0) := (others => '0');
signal C4 : std_logic_vector (7 downto 0) := (others => '0');
signal IP : std_logic_vector (15 downto 0) := (others => '0');
signal AdrA : std_logic_vector (7 downto 0) := (others => '0');
signal AdrB : std_logic_vector (7 downto 0) := (others => '0');
signal QA : std_logic_vector (7 downto 0) := (others => '0');
signal QB : std_logic_vector (7 downto 0) := (others => '0');
signal WBR : std_logic := '0';


begin

memInstruct : Mem_Instructions PORT MAP (
			CLK => CLK,
			Address => IP,     
			Dout => memInstructOut
			);
			
LIDI : FourReg PORT MAP (
			IA => memInstructOut(23 downto 16),
         IOP => memInstructOut(31 downto 24),
         IB => memInstructOut(15 downto 8),
         IC => memInstructOut(7 downto 0),
         OA => A1,
         OOP => OP1,
         OB => B1,
         OC => C1,
         CLK => CLK,
			RST => RST
			);
			
DIEX : FourReg PORT MAP (
			IA => A1,
         IOP => OP1,
         IB => B1,
         IC => C1,
         OA => A2,
         OOP => OP2,
         OB => B2,
         OC => C2,
         CLK => CLK,
			RST => RST
			);
			
EXMem : ThreeReg PORT MAP (
			IA => A2,
         IOP => OP2,
         IB => B2,
         OA => A3,
         OOP => OP3,
         OB => B3,
         CLK => CLK,
			RST => RST
			);
			
MemRE : ThreeReg PORT MAP (
			IA => A3,
         IOP => OP3,
         IB => B3,
         OA => A4,
         OOP => OP4,
         OB => B4,
         CLK => CLK,
			RST => RST
			);

br : banc_registres PORT MAP (
			 AddrA => x"04", 
          AddrB => x"08",
          AddrW => A4,
          W => WBR,
          DATA => B4,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
);
--
--LC : LogicCombi PORT MAP (
--           DIN => OP4,
--			  CLK => CLK,
--           DOUT => WBR
--			  );
WBR <= '1' when OP4 = x"01" or OP4 = x"02" or OP4 = x"03" or OP4 = x"04" or OP4 = x"06" else '0';

SA <= QA;
SB <= QB;

	process (clk)
		begin
		if rst = '1' then
			ip <= x"0000";
		elsif CLK'event and CLK = '1' then
			IP <= IP + x"0001";
		end if;
	end process;

end Behavioral;

