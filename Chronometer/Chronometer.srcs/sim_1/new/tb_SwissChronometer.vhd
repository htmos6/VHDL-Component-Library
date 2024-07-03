library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_SwissChronometer is
	generic 
	(
		c_clk_frequency : integer := 100_000;
		c_debounce_frequency : integer := 10
	);
end entity;


architecture Behavioral of tb_SwissChronometer is	
	constant period : time := 1 sec / real(c_clk_frequency);

	
	signal clk_i : std_logic := '0';
	signal start_i : std_logic := '0';
	signal reset_i : std_logic := '0';
	
	signal msec : integer := 0;
	signal sec : integer := 0;
	signal min : integer := 0;
	
	
	component SwissChronometer is
	generic 
	(
		c_clk_frequency : integer := 100_000_000;
		c_debounce_frequency : integer := 1_000
	);
	port 
	(
		clk_i : in std_logic;
		start_i : in std_logic;
		reset_i : in std_logic;
		msec_dec_o : out integer;
		sec_dec_o : out integer;
		min_dec_o : out integer
	);
	end component;
	

begin
	
	
	uut : SwissChronometer 
	generic map
	(
		c_clk_frequency => c_clk_frequency,
		c_debounce_frequency => c_debounce_frequency
	)
	port map
	(
		clk_i => clk_i,
		start_i => start_i,
		reset_i => reset_i,
		msec_dec_o => msec,
		sec_dec_o => sec,
		min_dec_o => min
	);


	P_CLK : process begin
		wait for period / 2;
		clk_i <= '0';	
		wait for period / 2;
		clk_i <= '1';
	end process;


	P_CHRONOMETER : process begin
		
		wait until rising_edge(clk_i);
		start_i <= '1';
		wait for 150 ms;
		start_i <= '0';
		wait until rising_edge(clk_i);
		
		wait for 5000 ms;

		report "TEST CASES COMPLETED SUCCESSFULLY" severity note;
        -- End simulation
        wait;
		
	end process;









end architecture;
