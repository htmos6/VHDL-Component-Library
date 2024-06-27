----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2024 15:11:56
-- Design Name: 
-- Module Name: NbitFullAdder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NbitFullAdder is
	generic 
	(
		N : integer := 4
	);
	port 
	(
		a_i : in std_logic_vector (N-1 downto 0);
		b_i : in std_logic_vector (N-1 downto 0);
		carry_i : in std_logic;
		
		out_o : out std_logic_vector (N-1 downto 0);
		carry_o : out std_logic
	);
end entity;


architecture Behavioral of NbitFullAdder is
	
	
	signal temp : std_logic_vector (N downto 0) := (others => '0');
	signal sum : std_logic_vector (N-1 downto 0) := (others => '0');

	component FullAdder is
	port 
	(
		a_i : in std_logic;
		b_i : in std_logic;
		carry_i : in std_logic;
		
		out_o : out std_logic;
		carry_o : out std_logic
	);
	end component;
	
begin
	
	N_BIT_ADDER : for k in 0 to N-1 generate
	
		n_bit_adder_k : FullAdder
		port map 
		(
			a_i => a_i(k),
			b_i => b_i(k),
			carry_i => temp(k),
			
			out_o => sum(k),
			carry_o => temp(k+1)
		);
	end generate;
	
	out_o <= sum;

	temp(0) <= carry_i;
	carry_o <= temp(N);

end architecture;
