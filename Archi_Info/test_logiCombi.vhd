--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:21:17 04/11/2016
-- Design Name:   
-- Module Name:   /mnt/3B4855713D95A63B/Common/Documents/INSA/4IR/Sem2/Systemes informatiques/Archi_Info/test_logiCombi.vhd
-- Project Name:  Archi_Info
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: LogicCombi
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_logiCombi IS
END test_logiCombi;
 
ARCHITECTURE behavior OF test_logiCombi IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT LogicCombi
    PORT(
         DIN : IN  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         DOUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal DIN : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal DOUT : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: LogicCombi PORT MAP (
          DIN => DIN,
          CLK => CLK,
          DOUT => DOUT
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		DIN <= x"00", x"02" after 50 ns;

      -- insert stimulus here 

      wait;
   end process;

END;
