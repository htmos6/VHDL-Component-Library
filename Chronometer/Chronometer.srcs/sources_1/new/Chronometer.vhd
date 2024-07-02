library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Chronometer is
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
end entity;




architecture Behavioral of Chronometer is

	signal ones_place_counter : std_logic_vector(3 downto 0) := (others => '0');
	signal tens_place_counter : std_logic_vector(3 downto 0) := (others => '0');

begin

	ones_bcd_o <= ones_place_counter;
	tens_bcd_o <= tens_place_counter;

	P_BCD_INCREMENTOR : process (clk_i) begin
		if (rising_edge(clk_i)) then 
				
			if (increment_i = '1') then 
				if (ones_place_counter = ones_place_limit) then
					if (tens_place_counter = tens_place_limit) then
						tens_place_counter <= (others => '0');
						ones_place_counter <= (others => '0');
					else
						tens_place_counter <= tens_place_counter + 1;
						ones_place_counter <= (others => '0');
					end if;
				else
					ones_place_counter <= ones_place_counter + 1;				
				end if;
			end if;
				
			if (reset_i = '1') then 
				ones_place_counter <= (others => '0');
				tens_place_counter <= (others => '0');
			end if;
			
		end if;
	end process;
	
	
	
	
	
	
end architecture;
