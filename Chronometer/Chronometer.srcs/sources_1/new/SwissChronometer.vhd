library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity SwissChronometer is
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
end entity;

architecture Behavioral of SwissChronometer is
	
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
	
	
	component Debounce is
		generic 
		(
			c_clk_frequency : integer := c_clk_frequency;
			c_debounce_frequency : integer := c_debounce_frequency; 
			c_signal_init : std_logic := '0' 
		);
		port 
		(
			clk_i : in std_logic;
			signal_i : in std_logic;
			signal_o : out std_logic
		);
	end component;
	
	constant c_msec_counter_limit : integer := c_clk_frequency / 100;
	constant c_sec_counter_limit : integer := 100;  -- Will count up to 100 msec, which will be 1 sec 
	constant c_min_counter_limit : integer := 60;
	
	signal msec_ones_bcd : std_logic_vector (3 downto 0) := (others => '0');
	signal msec_tens_bcd : std_logic_vector (3 downto 0) := (others => '0');
	signal sec_ones_bcd : std_logic_vector (3 downto 0) := (others => '0');
	signal sec_tens_bcd : std_logic_vector (3 downto 0) := (others => '0');
	signal min_ones_bcd : std_logic_vector (3 downto 0) := (others => '0');
	signal min_tens_bcd : std_logic_vector (3 downto 0) := (others => '0');
	
	signal increment_msec : std_logic := '0';
	signal increment_sec : std_logic := '0';
	signal increment_min : std_logic := '0';
	
	signal reset_debounced : std_logic := '0';
	signal start_debounced : std_logic := '0';
	signal start_debounced_previous : std_logic := '0';
	
	signal msec_counter : integer range 0 to c_msec_counter_limit := 0;
	signal sec_counter : integer range 0 to c_sec_counter_limit := 0;
	signal min_counter : integer range 0 to c_min_counter_limit := 0;
	
	type T_STATE is (S_STOP, S_CONTINUE);
	
	signal state : T_STATE := S_STOP;
		
	
begin
	msec_dec_o <= conv_integer(unsigned(msec_tens_bcd)) * 10 + conv_integer(unsigned(msec_ones_bcd));
	sec_dec_o <= conv_integer(unsigned(sec_tens_bcd)) * 10 + conv_integer(unsigned(sec_ones_bcd));
	min_dec_o <= conv_integer(unsigned(min_tens_bcd)) * 10 + conv_integer(unsigned(min_ones_bcd));

	-------------------------------------
	--
	-- 	Debounced Buttons Instantiation
	--
	-------------------------------------
	Debounce_Start_Button : Debounce
	generic map
	(
		c_clk_frequency => 100_000_000, 
		c_debounce_frequency => 10_000_000, -- 100 ns
		c_signal_init => '0'
	)
	port map
	(          
		clk_i => clk_i,
		signal_i => start_i,
		signal_o => start_debounced
	);
	
	Debounce_Reset_Button : Debounce
	generic map
	(
		c_clk_frequency => 100_000_000,
		c_debounce_frequency => 10_000_000, -- 100 ns
		c_signal_init => '0'
	)
	port map
	(          
		clk_i => clk_i,
		signal_i => reset_i,
		signal_o => reset_debounced
	);


	-------------------------------------
	--
	-- 	Chronometer Instantiation
	--
	-------------------------------------
	msec_chrono : Chronometer
	generic map 
	(
		ones_place_limit => 9,
	    tens_place_limit => 9
	)
	port map
	(
		clk_i => clk_i,
		increment_i => increment_msec,
		reset_i => reset_debounced,
		ones_bcd_o => msec_ones_bcd,
		tens_bcd_o => msec_tens_bcd
	);
	
	sec_chrono : Chronometer
	generic map 
	(
		ones_place_limit => 9,
	    tens_place_limit => 5
	)
	port map
	(
		clk_i => clk_i,
		increment_i => increment_sec,
		reset_i => reset_debounced,
		ones_bcd_o => sec_ones_bcd,
		tens_bcd_o => sec_tens_bcd
	);
	
	min_chrono : Chronometer
	generic map 
	(
		ones_place_limit => 9,
	    tens_place_limit => 5
	)
	port map
	(
		clk_i => clk_i,
		increment_i => increment_min,
		reset_i => reset_debounced,
		ones_bcd_o => min_ones_bcd,
		tens_bcd_o => min_tens_bcd
	);
	
	
	P_STATE : process (clk_i) begin 
		if (rising_edge(clk_i)) then
			
			start_debounced_previous <= start_debounced;
		
			-- If start button is pressed, updated state of the timer. 
 			if (start_debounced = '1' and start_debounced_previous = '0') then --   --\_ => previous is the right side of the signal => falling edge
				
				if (state = S_STOP) then 
					state <= S_CONTINUE;
				elsif (state = S_CONTINUE) then
					state <= S_STOP;
				end if;
				
			end if;
			
		end if;
	end process;
	
	
	P_TIMER : process (clk_i) begin 
		if (rising_edge(clk_i)) then

			-- *** In VHDL last assignment will be hold for the signal ***
			increment_msec <= '0';
			increment_sec <= '0';
			increment_min <= '0';
			
			-- If reset signal pressed, chronometers reset themselves.
			-- Reset helper signals. 
			if (reset_debounced = '1') then 
				msec_counter <= 0;
			    sec_counter <= 0;
			    min_counter <= 0;
			end if;
			
			if (state = S_CONTINUE) then 
				
				if (msec_counter = c_msec_counter_limit - 1) then 
					msec_counter <= 0;
					increment_msec <= '1';
					
					if (sec_counter = c_sec_counter_limit - 1) then 
						sec_counter <= 0;
						increment_sec <= '1';
						
						if (min_counter = c_min_counter_limit - 1) then 
							min_counter <= 0;
							increment_min <= '1';
						else 
							min_counter <= min_counter + 1; -- 1 s passed
						end if;
						
					else 
						sec_counter <= sec_counter + 1;
					end if;
					
				else 
					msec_counter <= msec_counter + 1;
				end if;

			end if;
			
		end if;
	end process;


end architecture;
