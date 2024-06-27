library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_Counter is
generic 
(
	c_clk_frequency : integer := 100
);
end entity;



architecture Behavioral of tb_Counter is

	component Counter is
		generic 
		(
			c_clk_frequency : integer := 100_000_000
		);
		port 
		(
			clk 		: in std_logic;
			switch 		: in std_logic_vector (1 downto 0); 
			ct     : out std_logic_vector (7 downto 0)
		);
	end component;
	
	signal clk 		: std_logic := '0';
	signal switch 	: std_logic_vector(1 downto 0) := "00";
	signal ct 	    : std_logic_vector (7 downto 0) := (others => '0');
	
	constant clk_period : time := 10 ms;

begin

	uut : Counter
	generic map 
	(
		c_clk_frequency => c_clk_frequency
	)
	port map 
	(
		clk 	=> clk,	
		switch 	=> switch,
		ct => ct 
	);

	
	-- Clock process definitions
	process
	begin
		clk <= '0'; 
		wait for clk_period / 2;
		clk <= '1'; 
		wait for clk_period / 2;
	end process;


	-- Stimulus process to apply test vectors
    stim_proc: process
    begin

        -- Test case 1: switch = "00" (2 seconds timer)
        switch <= "00";
        wait for 4 * 100 * clk_period; -- Wait for 4 sec
		wait for 1 ms;
        assert (ct = "00000010") report "Test case 1 failed" severity error;

        -- Test case 2: switch = "01" (1 second timer)
        switch <= "01";
        wait for 4 * 100 * clk_period; -- Wait for 4 sec
		wait for 1 ms;
        assert (ct = "00000100") report "Test case 2 failed" severity error;

        -- Test case 3: switch = "10" (500 ms timer)
        switch <= "10";
        wait for 4 * 100 * clk_period; -- Wait for 4 sec
		wait for 1 ms;
        assert (ct = "00001000") report "Test case 3 failed" severity error;

        -- Test case 4: switch = "11" (250 ms timer)
        switch <= "11";
        wait for 4 * 100 *  clk_period; -- Wait for 4 sec
		wait for 1 ms;
        assert (ct = "00010000") report "Test case 4 failed" severity error;

		report "TEST CASES COMPLETED SUCCESSFULLY" severity note;

        -- End simulation
        wait;
    end process stim_proc;







end architecture;
