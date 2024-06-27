----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.06.2024 19:34:21
-- Design Name: 
-- Module Name: Mux2X1 - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux2X1 is
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
end entity;




architecture Behavioral of Mux2X1 is
begin

	-----------------------------------------------
	-- PROCESS COMBINATIONAL DESIGN I
	-----------------------------------------------
    --
	-- out_o <= in0_i when sel_i = '0' else 
	--          in1_i;
	--
	-----------------------------------------------

	
	
	-----------------------------------------------
	-- PROCESS COMBINATIONAL DESIGN II
	-----------------------------------------------
	
	P_COMBINATIONAL : process (in0_i, in1_i, sel_i)
	begin
		if (sel_i = '0') then
			out_o <= in0_i;
		else
			out_o <= in1_i;
		end if;
	end process;
	
	-----------------------------------------------

end architecture;
