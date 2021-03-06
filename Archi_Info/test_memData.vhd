
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_memData IS
END test_memData;
 
ARCHITECTURE behavior OF test_memData IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal adr : std_logic_vector(15 downto 0) := (others => '0');
   signal din : std_logic_vector(7 downto 0) := (others => '0');
   signal rw : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal dout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memData PORT MAP (
          adr => adr,
          din => din,
          rw => rw,
          rst => rst,
          clk => clk,
          dout => dout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		--clk <='0', not(clk) after 5ns;
		rst <='1','0' after 20ns, '1' after 1000ns;
		rw <='1', '0' after 200ns;
		
		adr <=x"1111"; --, adr+1 after 5ns;
		din <=x"aa", x"33" after 400ns;
		
		
      wait;
   end process;

END;
