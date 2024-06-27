library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity Counter is
	---------------------------------------------------
	generic 
	(
		c_clk_frequency : integer := 100_000_000
	);
	port 
	(
		clk 		: in std_logic;
		switch 		: in std_logic_vector (1 downto 0); 
		ct     		: out std_logic_vector (7 downto 0)
	);
	---------------------------------------------------
end entity;


architecture Behavioral of Counter is
	---------------------------------------------------
	constant c_timer_2sec_lim    		: integer := c_clk_frequency * 2; 
	constant c_timer_1sec_lim    		: integer := c_clk_frequency ; 
	constant c_timer_500msec_lim 		: integer := c_clk_frequency / 2; 
	constant c_timer_250msec_lim 		: integer := c_clk_frequency / 4; 
	
	signal timer_lim 					: integer range 0 to c_timer_2sec_lim := 0;
	signal clk_cycle_counter 			: integer range 0 to c_timer_2sec_lim := 0;
	
	signal counter_internal 			: std_logic_vector(7 downto 0) := (others => '0');
	---------------------------------------------------
begin
	---------------------------------------------------
	ct <= counter_internal;
	
	timer_lim <= 	c_timer_2sec_lim 	when switch = "00" else
					c_timer_1sec_lim 	when switch = "01" else
					c_timer_500msec_lim when switch = "10" else
					c_timer_250msec_lim;


	process (clk) begin 
		if (rising_edge(clk)) then
			
			if (clk_cycle_counter >= timer_lim) then 
				clk_cycle_counter <= 0;
				counter_internal <= counter_internal + 1; 
			else	
				clk_cycle_counter <= clk_cycle_counter + 1;			
			end if;
			
		end if;
	end process;
	

	---------------------------------------------------
end architecture;
