library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity tb_Chronometer is
	generic
	(
		ones_place_limit : integer := 9;
		tens_place_limit : integer := 9	
	);
end tb_Chronometer;


architecture Behavioral of tb_Chronometer is

	component Chronometer is
		generic 
		(
			ones_place_limit : integer := 9;
			tens_place_limit : integer := 5	
		);
		port 
		(
			clk_i : in std_logic;
			increment_i : in std_logic;
			reset_i : in std_logic;
			ones_bcd_o : out std_logic_vector (3 downto 0);
			tens_bcd_o : out std_logic_vector (3 downto 0)
		);
	end component;
	
	signal clk_i : std_logic := '0';
	signal increment_i : std_logic := '0';
	signal reset_i : std_logic := '0';
	signal ones_bcd_o : std_logic_vector (3 downto 0) := (others => '0');
	signal tens_bcd_o : std_logic_vector (3 downto 0) := (others => '0');
	
	constant frequency : integer := 100_000_000;
	constant period : time := 1 sec / real(frequency);
	
begin


	uut : Chronometer
	generic map
	(
		ones_place_limit => ones_place_limit,
		tens_place_limit => tens_place_limit
	)
	port map
	(
		clk_i => clk_i,
		increment_i => increment_i,
		reset_i => reset_i,
		ones_bcd_o => ones_bcd_o,
		tens_bcd_o => tens_bcd_o
	);


	P_CLK : process begin
		wait for period / 2;
		clk_i <= '0';	
		wait for period / 2;
		clk_i <= '1';
	end process;
	
	
	P_CHRONOMETER : process begin
		
		increment_i <= '1';
		
		
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		wait until rising_edge(clk_i);
		
		
		reset_i <= '1';
		wait until rising_edge(clk_i);
		wait for 1 ns;
		assert (ones_bcd_o = 0 and tens_bcd_o = 0) report "Test case RESET failed" severity error;  
		
		reset_i <= '0';
		wait until rising_edge(clk_i);

		
		for i in 0 to 99 loop
			assert (i mod 10 = ones_bcd_o) report "Test case ones_bcd failed" severity error;  
			assert (integer(i/10) = tens_bcd_o) report "Test case tens_bcd failed" severity error;  
		
			wait until rising_edge(clk_i);
		end loop;
		
		
		assert (ones_bcd_o = X"0") report "Test case ones_bcd failed" severity error;
		assert (tens_bcd_o = X"0") report "Test case ones_bcd failed" severity error;


		report "TEST CASES COMPLETED SUCCESSFULLY" severity note;
        -- End simulation
        wait;
		
	end process;
	






end Behavioral;
