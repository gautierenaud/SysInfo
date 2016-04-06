--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:16:40 04/06/2016
-- Design Name:   
-- Module Name:   /mnt/3B4855713D95A63B/Common/Documents/INSA/4IR/Sem2/Systemes informatiques/Archi_Info/test_reg.vhd
-- Project Name:  Archi_Info
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: banc_registres
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
 
ENTITY test_reg IS
END test_reg;
 
ARCHITECTURE behavior OF test_reg IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal AddrA : std_logic_vector(7 downto 0) := (others => '0');
   signal AddrB : std_logic_vector(7 downto 0) := (others => '0');
   signal AddrW : std_logic_vector(7 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: banc_registres PORT MAP (
          AddrA => AddrA,
          AddrB => AddrB,
          AddrW => AddrW,
          W => W,
          DATA => DATA,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process CLK_process;
 

   -- Stimulus process
   stim_proc: process
   begin
	
      wait for CLK_period*10;

		W <= '0', '1' after 100 ns;
		AddrW <= x"05", x"06" after 150 ns;
		AddrA <= x"05";
		AddrB <= x"06";
		DATA <= x"11";

		RST <= '1', '0' after 200 ns;
      -- insert stimulus here 

      wait;
   end process;

END;
