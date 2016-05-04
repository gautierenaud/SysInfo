
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_Processeur IS
END test_Processeur;
 
ARCHITECTURE behavior OF test_Processeur IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Processeur
    PORT(
         Clk : IN  std_logic;
         RST : IN  std_logic;
         SA : OUT  std_logic_vector(7 downto 0);
         SB : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal RST : std_logic := '0';

 	--Outputs
   signal SA : std_logic_vector(7 downto 0);
   signal SB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Processeur PORT MAP (
          Clk => Clk,
          RST => RST,
          SA => SA,
          SB => SB
        );

--   -- Clock process definitions
--   Clk_process :process
--   begin
--		Clk <= '0';
--		wait for Clk_period/2;
--		Clk <= '1';
--		wait for Clk_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		RST <= '1', '0' after 100 ns;

      -- insert stimulus here 
		CLK <= not CLK after Clk_period/2;

   end process;

END;
