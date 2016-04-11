
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
signal LIDIAOut : std_logic_vector (7 downto 0) := (others => '0');
signal DIEXAOut : std_logic_vector (7 downto 0) := (others => '0');
signal EXMemAOut : std_logic_vector (7 downto 0) := (others => '0');
signal MemReAOut : std_logic_vector (7 downto 0) := (others => '0');
signal OP0 : std_logic_vector (7 downto 0) := (others => '0');
signal LIDIOPOut : std_logic_vector (7 downto 0) := (others => '0');
signal DIEXOPOut : std_logic_vector (7 downto 0) := (others => '0');
signal EXMemOPOut : std_logic_vector (7 downto 0) := (others => '0');
signal MemReOPOut : std_logic_vector (7 downto 0) := (others => '0');
signal B0 : std_logic_vector (7 downto 0) := (others => '0');
signal LIDIBOut : std_logic_vector (7 downto 0) := (others => '0');
signal DIEXBOut : std_logic_vector (7 downto 0) := (others => '0');
signal EXMemBOut : std_logic_vector (7 downto 0) := (others => '0');
signal MemReBOut : std_logic_vector (7 downto 0) := (others => '0');
signal C0 : std_logic_vector (7 downto 0) := (others => '0');
signal LIDICOut : std_logic_vector (7 downto 0) := (others => '0');
signal DIEXCOut : std_logic_vector (7 downto 0) := (others => '0');
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
         OA => LIDIAOut,
         OOP => LIDIOPOut,
         OB => LIDIBOut,
         OC => LIDICOut,
         CLK => CLK,
			RST => RST
			);
			
DIEX : FourReg PORT MAP (
			IA => LIDIAOut,
         IOP => LIDIOPOut,
         IB => LIDIBOut,
         IC => LIDICOut,
         OA => DIEXAOut,
         OOP => DIEXOPOut,
         OB => DIEXBOut,
         OC => DIEXCOut,
         CLK => CLK,
			RST => RST
			);
			
EXMem : ThreeReg PORT MAP (
			IA => DIEXAOut,
         IOP => DIEXOPOut,
         IB => DIEXBOut,
         OA => EXMemAOut,
         OOP => EXMemOPOut,
         OB => EXMemBOut,
         CLK => CLK,
			RST => RST
			);
			
MemRE : ThreeReg PORT MAP (
			IA => EXMemAOut,
         IOP => EXMemOPOut,
         IB => EXMemBOut,
         OA => MemReAOut,
         OOP => MemReOPOut,
         OB => MemReBOut,
         CLK => CLK,
			RST => RST
			);

br : banc_registres PORT MAP (
			 AddrA => AdrA, 
          AddrB => AdrB,
          AddrW => MemReAOut,
          W => WBR,
          DATA => MemReBOut,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
);

LC : LogicCombi PORT MAP (
           DIN => MemReOPOut,
			  CLK => CLK,
           DOUT => WBR
			  );




SA <= QA;
SB <= QB;

end Behavioral;

