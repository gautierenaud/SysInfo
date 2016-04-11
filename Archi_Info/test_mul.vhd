
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_mul IS
END test_mul;
 
ARCHITECTURE behavior OF test_mul IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Multiplexer
    PORT(
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         S : IN  std_logic;
         Z : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');
   signal S : std_logic := '0';

 	--Outputs
   signal Z : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Multiplexer PORT MAP (
          A => A,
          B => B,
          S => S,
          Z => Z
        );


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		S <= '0', '1' after 50 ns, '0' after 100 ns;
		A <= x"09", x"10" after 25 ns, x"40" after 50 ns, x"08" after 75 ns;
		B <= x"03", x"21" after 25 ns, x"25" after 50 ns, x"89" after 75 ns;

      wait;
   end process;

END;
