----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2024 13:20:47
-- Design Name: 
-- Module Name: FullAdder - Behavioral
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

entity FullAdder is
port 
(
	a_i : in std_logic;
	b_i : in std_logic;
	carry_i : in std_logic;
	
	out_o : out std_logic;
	carry_o : out std_logic
);
end entity;

architecture Behavioral of FullAdder is

	component HalfAdder is
	port 
	( 
		a_i : in std_logic;
		b_i : in std_logic;
		
		out_o : out std_logic;
		carry_o : out std_logic
	);
	end component;
	
	signal carry_HA_1 : std_logic := '0';
	signal out_HA_1 : std_logic := '0';
	
	signal carry_HA_2 : std_logic := '0';
	signal out_HA_2 : std_logic := '0';

	
begin
	
	HalfAdder1 : HalfAdder
	port map 
	(
		a_i => a_i,
		b_i => b_i,
	
		out_o => out_HA_1,
		carry_o => carry_HA_1
	);

	HalfAdder2 : HalfAdder
	port map 
	(
		a_i => out_HA_1,
		b_i => carry_i,
	
		out_o => out_HA_2,
		carry_o => carry_HA_2
	);
	
	carry_o <= carry_HA_1 or carry_HA_2;
	out_o <= out_HA_2;
	
end architecture;
