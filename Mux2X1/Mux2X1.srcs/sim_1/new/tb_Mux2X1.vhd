----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.06.2024 15:29:24
-- Design Name: 
-- Module Name: tb_Mux2X1 - Behavioral
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

entity tb_Mux2X1 is
generic 
(
	N : integer := 8
);
end entity;

-- Copy entity as a component
-- Define signals that will be connected as input & output
-- Initialize input signals with 0
-- Connect signals with :
-- 							generic map & port map



architecture Behavioral of tb_Mux2X1 is
	
	component Mux2X1 is
		generic
		(
			N : integer range 0 to 32 := 8
		);
		port 
		(
			in0_i : in std_logic_vector(N-1 downto 0);
			in1_i : in std_logic_vector(N-1 downto 0);
			sel_i : in std_logic;
			
			out_o : out std_logic_vector(N-1 downto 0)	
		);
	end component;
	
	-- Declare input signals
	-- Initialize input signals with 0	
	
			
	signal in0_i : std_logic_vector(N-1 downto 0) := (others => '0');
	signal in1_i : std_logic_vector(N-1 downto 0) := (others => '0');
	signal sel_i : std_logic := '0';
	 
	signal out_o : std_logic_vector(N-1 downto 0);

begin
	
	uut : Mux2X1
	generic map
	(
		N => 8
	)
	port map
	(
		in0_i => in0_i,
		in1_i => in1_i,
		sel_i => sel_i,

		out_o => out_o
	);
	
	
	-- Stimulus process to apply test vectors
    stim_proc: process
    begin
        -- Test case 1:
        in0_i <= X"AB"; in1_i <= X"BC"; sel_i <= '0';
        wait for 10 ns;
        assert (out_o = X"AB") report "Test case 1 failed" severity error;

        -- Test case 2:
        in0_i <= X"AB"; in1_i <= X"BC"; sel_i <= '1';
        wait for 10 ns;
        assert (out_o =  X"BC") report "Test case 2 failed" severity error;
		
		-- Test case 3:
        in0_i <= X"AB"; in1_i <= X"BC"; sel_i <= '0';
        wait for 10 ns;
        assert (out_o =  X"AB") report "Test case 3 failed" severity error;
		
		-- Test case 4:
        in0_i <= X"AC"; in1_i <= X"BC"; sel_i <= '0';
        wait for 10 ns;
        assert (out_o =  X"AC") report "Test case 4 failed" severity error;
		
		-- Test case 5:
        in0_i <= X"AC"; in1_i <= X"BC"; sel_i <= '1';
        wait for 10 ns;
        assert (out_o =  X"BC") report "Test case 5 failed" severity error;
		
		-- Test case 6:
        in0_i <= X"AC"; in1_i <= X"EF"; sel_i <= '1';
        wait for 10 ns;
        assert (out_o =  X"EF") report "Test case 6 failed" severity error;

        -- End simulation
        wait;
    end process stim_proc;


end architecture;
