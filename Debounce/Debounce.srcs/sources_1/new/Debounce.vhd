library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Debounce is
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
end entity;


architecture Behavioral of Debounce is

	type T_STATE is (S_INITIAL, S_ZERO, S_ZERO2ONE, S_ONE, S_ONE2ZERO);

	constant c_timer_lim : integer := c_clk_frequency / c_debounce_frequency; -- To hold 1 ms, need to count till -> 1ms/10ns = 100_000 times
	
	signal timer : integer range 0 to c_timer_lim := 0;
	signal timer_enable : std_logic := '0';
	signal timer_done : std_logic := '0';
	
	signal state : T_STATE := S_INITIAL;

begin

	P_STATE : process (clk_i) begin
	if (rising_edge(clk_i)) then 
		
		case state is 
			when S_INITIAL =>
				if (c_signal_init = '0') then 
					signal_o <= c_signal_init;
					state <= S_ZERO;
				else 
					signal_o <= c_signal_init;
					state <= S_ONE;
				end if;
			
			when S_ZERO =>
				signal_o <= '0';
				
				if (signal_i = '1') then 
					state <= S_ZERO2ONE;
				end if;

			when S_ZERO2ONE => 
				signal_o <= '0';
				timer_enable <= '1';
				
				if (timer_done = '1') then
					state <= S_ONE;
					timer_enable <= '0';
				end if;
				
				if (signal_i = '0') then
					state <= S_ZERO;
					timer_enable <= '0';
				end if;
			
			when S_ONE =>
				signal_o <= '1';
				
				if (signal_i = '0') then 
					state <= S_ONE2ZERO;
				end if;
			
			when S_ONE2ZERO =>
				signal_o <= '1';
				timer_enable <= '1';
				
				if (timer_done = '1') then
					state <= S_ZERO;
					timer_enable <= '0';
				end if;
				
				if (signal_i = '1') then
					state <= S_ONE;
					timer_enable <= '0';
				end if;
		end case;

	end if;
	end process;
	
	
	P_TIMER : process (clk_i) begin
	if (rising_edge(clk_i)) then 
		
		if (timer_enable = '1') then 
			if (timer = c_timer_lim - 1) then 
				timer_done <= '1';
				timer <= 0;
			else 
				timer_done <= '0';
				timer <= timer + 1;			
			end if;
		else 
			timer_done <= '0';
			timer <= 0;
		end if;

	end if;
	end process;

end architecture;
