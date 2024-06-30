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
	signal signal_o : std_logic := '0';
	
	constant c_clk_period : time := 1 ns / real(c_clk_frequency);
	
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
	
		-- Test case 1: signal_i = '0'
		signal_i <= '0';
		wait for 1 ns;

		-- Change signal_i to '1' and wait for the half of the debounce period
		signal_i <= '1';
		wait for 5 * c_clk_period;
		
		-- Assert that signal_o remains '0' initially (at the middle of the debounce period)
		assert (signal_o = '0') report "Test case 1 failed" severity error;

		-- Wait for another debounce period to ensure stable output
		wait for 5 * c_clk_period;

		-- Assert that signal_o becomes '1' after debounce period
		assert (signal_o = '1') report "Test case 1 failed" severity error;

	
	
	
	
	end process;
	
	
end architecture;
