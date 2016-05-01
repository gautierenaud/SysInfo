
library IEEE;
library STD;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use STD.TEXTIO.ALL;
use IEEE.std_logic_textio.all;

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
			AddrA : IN  std_logic_vector(3 downto 0);
			AddrB : IN  std_logic_vector(3 downto 0);
			AddrW : IN  std_logic_vector(3 downto 0);
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
			adr : IN  std_logic_vector(7 downto 0);
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
			
signal CK : std_logic := '0';
signal LIDI_CLK : std_logic := '0';

-- Gestion des Aléas --
signal Alea : std_logic := '0';
signal nopInstruct : std_logic_vector (31 downto 0) := (others => '0');
signal nopCPT : std_logic_vector (2 downto 0) := (others => '0');
signal mem_saveInstruct : std_logic_vector (31 downto 0) := (others => '0');
-- Gestion des Aléas -- 

-- Processor -- 
signal IP : std_logic_vector (15 downto 0) := (others => '0');
signal IP_Counting : std_logic := '1';
-- Processor -- 

-- Mem Instruct --
signal memInstructOut : std_logic_vector (31 downto 0) := (others => '0');
-- Mem Instruct --

-- LI/DI --
-- intermediate signal for the LIDI input
signal LIDIInter : std_logic_vector (31 downto 0) := (others => '0');
-- intermediate signal for the LIDI outpt
signal LIDIInterOUT : std_logic_vector (31 downto 0) := (others => '0');
signal LIDIIn : std_logic_vector (31 downto 0) := (others => '0');
signal LIDIOut : std_logic_vector (31 downto 0) := (others => '0');
-- LI/DI --

-- Mem Registers -- 
signal AdrA : std_logic_vector (7 downto 0) := (others => '0');
signal AdrB : std_logic_vector (7 downto 0) := (others => '0');
signal QA : std_logic_vector (7 downto 0) := (others => '0');
signal QB : std_logic_vector (7 downto 0) := (others => '0');
signal WBR : std_logic := '0';
signal BRSIN : std_logic := '0';
-- Mem Registers -- 

-- DI/EX --
signal DIEXBIn : std_logic_vector (7 downto 0) := (others => '0');
signal DIEXAOut : std_logic_vector (7 downto 0) := (others => '0');
signal DIEXOPOut : std_logic_vector (7 downto 0) := (others => '0');
signal DIEXBOut : std_logic_vector (7 downto 0) := (others => '0');
signal DIEXCOut : std_logic_vector (7 downto 0) := (others => '0');
-- DI/EX --

-- ALU --
signal CtrlALuIN : std_logic_vector(2 downto 0) := "000";
signal AluNOut : std_logic := '0';
signal AluOOut : std_logic := '0';
signal AluCOut : std_logic := '0';
signal AluZOut : std_logic := '0';
signal AluSOut : std_logic_vector (7 downto 0) := (others => '0');
-- ALU --

-- EX/Mem --
signal EXMemAOut : std_logic_vector (7 downto 0) := (others => '0');
signal EXMemOPOut : std_logic_vector (7 downto 0) := (others => '0');
signal EXMemBOut : std_logic_vector (7 downto 0) := (others => '0');
signal EXMemBIn : std_logic_vector (7 downto 0) := (others => '0');
-- EX/Mem -- 

-- Mem Data --
signal MUXMemDOUT : std_logic_vector (7 downto 0) := (others => '0');
signal MUXMemDIN : std_logic_vector (7 downto 0) := (others => '0');
signal MemDOUT : std_logic_vector (7 downto 0) := (others => '0');
signal LCMemD : std_logic := '0';
-- Mem Data --

-- Mem/Re --
signal MemReAOut : std_logic_vector (7 downto 0) := (others => '0');
signal MemReOPOut : std_logic_vector (7 downto 0) := (others => '0');
signal MemReBOut : std_logic_vector (7 downto 0) := (others => '0');
-- Mem/Re --

begin

memInstruct : Mem_Instructions PORT MAP (
			CLK => LIDI_CLK,
			Address => IP,     
			Dout => memInstructOut
			);
			
LIDI : FourReg PORT MAP (
			IA => LIDIIn(23 downto 16),
         IOP => LIDIIn(31 downto 24),
         IB => LIDIIn(15 downto 8),
         IC => LIDIIn(7 downto 0),
         OA => LIDIInterOut(23 downto 16),
         OOP => LIDIInterOut(31 downto 24),
         OB => LIDIInterOut(15 downto 8),
         OC => LIDIInterOut(7 downto 0),
         CLK => LIDI_CLK,
			RST => RST
			);
			
DIEX : FourReg PORT MAP (
			IA => LIDIOut(23 downto 16),
         IOP => LIDIOut(31 downto 24),
         IB => DIEXBIn,
         IC => QB,
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
         IB => EXMemBIn,
         OA => EXMemAOut,
         OOP => EXMemOPOut,
         OB => EXMemBOut,
         CLK => CLK,
			RST => RST
			);
			
MemRE : ThreeReg PORT MAP (
			IA => EXMemAOut,
         IOP => EXMemOPOut,
         IB => MUXMemDOUT,
         OA => MemReAOut,
         OOP => MemReOPOut,
         OB => MemReBOut,
         CLK => CLK,
			RST => RST
			);

br : banc_registres PORT MAP (
			 AddrA => LIDIOut(11 downto 8), 
          AddrB => LIDIOut(3 downto 0),
          AddrW => MemReAOut(3 downto 0),
          W => WBR,
          DATA => MemReBOut,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
);

ALU: UAL PORT MAP (
	A => DIEXBOut,
	B => DIEXCOut,
	Ctrl_Alu => CtrlALuIN,
	N => AluNOut,
	O => ALuOOut,
	Z => AluZOut,
	C => AluCOut,
	S => AluSOut
);

MemD: memData PORT MAP(
	adr => MuxMemDIN,
	din => EXMemBOut,
	rw => LCMemD,
	rst => RST,
	clk => CLK,
	dout => MemDOUT
);

-- Multiplexer for the LIDI IN
LIDI_CLK <= CLK when IP_Counting = '1' else '0';
LIDIIN <= memInstructOut;

-- Multiplexer to go out of the LIDI
LIDIOut <= mem_saveInstruct when nopCpt = "100" else nopInstruct when Alea = '1' else LIDIInterOut;


-- Multiplexer for the registry memory
DIEXBIn <= LIDIOut(15 downto 8) when (LIDIOut(31 downto 24) = x"06" or LIDIOut(31 downto 24) = x"07") else QA;

-- LC for writing in register memory
WBR <= '1' when MemReOPOut = x"01" or MemReOPOut = x"02" or MemReOPOut = x"03" or MemReOPOut = x"04" or MemReOPOut = x"06" or MemReOPOut = x"05" or MemReOPOut = x"07" else '0';


-------- LOGIC FOR THE UAL --------
-- LC for the ALU
CtrlAluIN <= DIEXOPOut(2 downto 0) when DIEXOPOUT = x"01" or DIEXOPOUT = x"02" or DIEXOPOUT = x"03" or DIEXOPOUT = x"04" else "000";
-- Multiplexer for ALU
EXMemBIn <= AluSOut when (DIEXOPOUT = x"01" or DIEXOPOUT = x"02" or DIEXOPOUT = x"03" or DIEXOPOUT = x"04") else DIEXBOut;


-------- LOGIC FOR THE DATA MEMORY ---------
-- LC
LCMemD <= '1' when ExMemOPOut = x"08" else '0';
-- Multiplexers
MUXMemDIN <= ExMemAOut when EXMemOPOut = x"08" else ExMemBOut;
MUXMemDOUT <= MemDOUT when EXMemOPOut = x"07" else ExMemBOut;

SA <= QA;
SB <= QB;
	
	process (clk)
		begin
		if CLK'event and CLK = '1' then
		
			-- si on trouve un aléas
			if ((x"01" <= LIDIIn(31 downto 24) and LIDIIn(31 downto 24) <= x"05")
				and ((x"01" <= LIDIOut(31 downto 24) and LIDIOut(31 downto 24) <= x"06"))
					and ((LIDIIn(15 downto 8) = LIDIOut(23 downto 16))
						or ((LIDIIn(7 downto 0) = LIDIOut(23 downto 16) and (x"01" <= LIDIIn(31 downto 24) and LIDIIn(31 downto 24) <= x"04")))))
			then
				alea <= '1';
				nopCpt <= "000";
				IP_Counting <= '0';
				mem_saveInstruct <= memInstructOut;
				write(output, "Aléa! ");
			end if;
			
			if rst = '1' then
				IP <= x"0000";
			else
				-- si on a besoin de lire un entrée + si on vient d'écrire qqchose + @qqchose == @entrée
				if Alea = '1' and not(((x"01" <= LIDIIn(31 downto 24) and LIDIIn(31 downto 24) <= x"05")
					and ((x"01" <= LIDIOut(31 downto 24) and LIDIOut(31 downto 24) <= x"06"))
						and ((LIDIIn(15 downto 8) = LIDIOut(23 downto 16))
							or ((LIDIIn(7 downto 0) = LIDIOut(23 downto 16) and (x"01" <= LIDIIn(31 downto 24) and LIDIIn(31 downto 24) <= x"04")))))) then
					if nopCpt = "011" then
						IP_Counting <= '1';
						nopCpt <= nopCpt + '1';
					elsif nopCpt = "100" then
						alea <= '0';
						nopCpt <= "000";
						mem_saveInstruct <= x"00000000";
					else
						nopCpt <= nopCpt + '1';
					end if;
				end if;
				if IP_Counting = '1' then
					IP <= IP + x"0001";
				end if;
			end if;
		end if;
	end process;
end Behavioral;

