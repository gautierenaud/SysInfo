-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT Mem_Instructions
          PORT(
                  CLK : IN std_logic;
                  Address : IN std_logic_vector(15 downto 0);       
                  Dout : OUT std_logic_vector(31 downto 0)
                  );
          END COMPONENT;

          SIGNAL t_CLK :  std_logic := '0';
          SIGNAL t_Address :  std_logic_vector(15 downto 0) := (others => '0');
          SIGNAL t_Dout :  std_logic_vector(31 downto 0) := (others => '0');
          

  BEGIN

  -- Component Instantiation
          uut: Mem_Instructions PORT MAP(
                  CLK => t_CLK,
                  Address => t_Address,
						Dout => t_Dout
          );


  --  Test Bench Statements
     tb : PROCESS
     BEGIN

        -- wait for 100 ns; -- wait until global set/reset completes
			t_CLK <= '0';
        -- Add user defined stimulus here

			t_CLK <= not t_CLK after 5ns;

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
