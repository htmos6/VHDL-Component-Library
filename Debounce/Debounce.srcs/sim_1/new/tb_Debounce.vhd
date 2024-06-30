library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_Debounce is
	generic 
	(
		c_clk_frequency : integer := 100_000_000;
		c_debounce_frequency : integer := 10_000_000;     
		c_signal_init : std_logic := '0'  	
	);
end entity;


architecture Behavioral of tb_Debounce is
	
	component Debounce is
		generic 
		(
			c_clk_frequency : integer := 100_000_000; -- 1 cycle for clock time = 1/100_000_000 = 10ns
			c_debounce_frequency : integer := 1_000; -- 1 cycle for debounce time = 1/1000 = 1ms
			c_signal_init : std_logic := '0' -- Will be used in the initial state to determine exact state.
		);
		port 
		(
			clk_i : in std_logic;
			signal_i : in std_logic;
			signal_o : out std_logic
		);
	end component;

	signal clk_i : std_logic := '0';
	signal signal_i : std_logic := '0';
	signal signal_o : std_logic := '1';
	
	constant c_clk_period : time := 1 sec / real(c_clk_frequency);
	constant debounce_stability_time : time := 1 sec / real(c_debounce_frequency);
	
begin

	uut : Debounce
	generic map
	(
		c_clk_frequency => c_clk_frequency,
		c_debounce_frequency => c_debounce_frequency,
		c_signal_init => c_signal_init		
	)
	port map 
	(
		clk_i => clk_i,	
		signal_i => signal_i,
		signal_o => signal_o 
	);
	
	
	PROCESS_CLK : process begin
		clk_i <= '0';
		wait for c_clk_period / 2;
		clk_i <= '1';
		wait for c_clk_period / 2;
	end process;
	
	
	PROCESS_DEBOUNCE : process begin
	
		-- Test case 1: signal_i transitions from '0' to '1'
		wait for 100 ns;

		signal_i <= '0';
		wait until rising_edge(clk_i);

		-- Change signal_i to '1' and wait for half of the debounce period
		signal_i <= '1';
		wait for debounce_stability_time / 2;
		wait for 80 ns;

		-- Assert that signal_o remains '0' initially (at the middle of the debounce period)
		assert (signal_o = '0') report "Test case 1.1 failed" severity error;

		-- Complete another debounce period to ensure stable output
		wait for debounce_stability_time / 2;
		wait for 80 ns;

		-- Assert that signal_o becomes '1' after debounce period
		assert (signal_o = '1') report "Test case 1.2 failed" severity error;



		-- Test case 2: signal_i transitions from '1' to '0'
		wait until rising_edge(clk_i);
		signal_i <= '0';

		-- Change signal_i to '0' and wait for half of the debounce period
		wait for debounce_stability_time / 2;
		wait for 80 ns;

		-- Assert that signal_o remains '1' initially (at the middle of the debounce period)
		assert (signal_o = '1') report "Test case 2.1 failed" severity error;

		-- Complete another debounce period to ensure stable output
		wait for debounce_stability_time / 2;
		wait for 80 ns;

		-- Assert that signal_o becomes '0' after debounce period
		assert (signal_o = '0') report "Test case 2.2 failed" severity error;



		-- Test case 3: signal_i transitions from '0' to '1' to '0'
		wait until rising_edge(clk_i);

		-- Set signal_i to '1' and wait for a fraction of the debounce period
		signal_i <= '1';
		wait for debounce_stability_time / 5;

		-- Set signal_i back to '0' and wait for the same fraction of the debounce period
		signal_i <= '0';
		wait for debounce_stability_time / 5;

		-- Assert that signal_o remains '0' (debouncing in progress)
		assert (signal_o = '0') report "Test case 3.1 failed" severity error;

		-- Set signal_i to '1' again and wait for the same fraction of the debounce period
		signal_i <= '1';
		wait for debounce_stability_time / 5;

		-- Assert that signal_o remains '0' (debouncing in progress)
		assert (signal_o = '0') report "Test case 3.2 failed" severity error;

		-- Wait for the complete debounce period to ensure stable output
		wait for debounce_stability_time / 5;

		-- Assert that signal_o remains '0' at the end of the debounce period
		assert (signal_o = '0') report "Test case 3.3 failed" severity error;


        report "TEST CASES COMPLETED SUCCESSFULLY" severity note;
        -- End simulation
        wait;
	
	end process;
	
	
end architecture;
