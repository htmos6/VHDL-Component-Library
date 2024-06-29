library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_Debounce is
	generic 
	(
		c_clk_frequency 		: integer 		:= 100_000_000;
		c_debounce_frequency    : integer 		:= 1_000;     
		c_signal_init  			: std_logic 	:= '0'  	
	);
end entity;


architecture Behavioral of tb_Debounce is
	
	component Debounce is
		generic 
		(
			c_clk_frequency 	  : integer     := 100_000_000;    -- 1 cycle for clock time = 1/100_000_000 = 10ns
			c_debounce_frequency  : integer     := 1_000;          -- 1 cycle for debounce time = 1/1000 = 1ms
			c_signal_init  		  : std_logic 	:= '0'  		   -- Will be used in the initial state to determine exact state.
		);
		port 
		(
			clk_i				  : in std_logic;
			signal_i			  : in std_logic;
			signal_o			  : out std_logic
		);
	end component;

	signal clk_i				  : std_logic   := '0';
	signal signal_i				  : std_logic   := '0';
	signal signal_o				  : std_logic   := '0';
	
	constant c_clk_period  : time := 1 ns / real(c_clk_frequency);
	
begin

	uut : Debounce
	generic map
	(
		c_clk_frequency 	      => c_clk_frequency,
		c_debounce_frequency      => c_debounce_frequency,
		c_signal_init  		      => c_signal_init		
	)
	port map 
	(
		clk_i					  => clk_i,	
		signal_i                  => signal_i,
		signal_o                  => signal_o 
	);
	
	
	PROCESS_CLK : process (clk_i) begin
		clk_i <= '0';
		wait for c_clk_period / 2;
		clk_i <= '1';
		wait for c_clk_period / 2;
	end process;
	
	
end architecture;
