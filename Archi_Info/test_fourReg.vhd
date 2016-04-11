LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_fourReg IS
END test_fourReg;
 
ARCHITECTURE behavior OF test_fourReg IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FourReg
    PORT(
         IA : IN  std_logic_vector(7 downto 0);
         IOP : IN  std_logic_vector(7 downto 0);
         IB : IN  std_logic_vector(7 downto 0);
         IC : IN  std_logic_vector(7 downto 0);
         OA : OUT  std_logic_vector(7 downto 0);
         OOP : OUT  std_logic_vector(7 downto 0);
         OB : OUT  std_logic_vector(7 downto 0);
         OC : OUT  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         RST : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal IA : std_logic_vector(7 downto 0) := (others => '0');
   signal IOP : std_logic_vector(7 downto 0) := (others => '0');
   signal IB : std_logic_vector(7 downto 0) := (others => '0');
   signal IC : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';

 	--Outputs
   signal OA : std_logic_vector(7 downto 0);
   signal OOP : std_logic_vector(7 downto 0);
   signal OB : std_logic_vector(7 downto 0);
   signal OC : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FourReg PORT MAP (
          IA => IA,
          IOP => IOP,
          IB => IB,
          IC => IC,
          OA => OA,
          OOP => OOP,
          OB => OB,
          OC => OC,
          CLK => CLK,
			 RST => RST
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
      wait for CLK_period*10;

		IA <= x"05", x"45" after 125 ns;

		RST <= '0', '1' after 500 ns; 
      -- insert stimulus here 

      wait;
   end process;

END;
