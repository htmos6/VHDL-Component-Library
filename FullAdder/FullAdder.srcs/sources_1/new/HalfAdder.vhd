----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.06.2024 00:08:29
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
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity HalfAdder is
port 
( 
	a_i : in std_logic;
	b_i : in std_logic;
	
	out_o : out std_logic;
	carry_o : out std_logic
);
end HalfAdder;

architecture Behavioral of HalfAdder is

begin

	P_COMBINATIONAL : process (a_i, b_i)
	begin
		out_o <= a_i xor b_i;
		carry_o <= a_i and b_i;	
	end process P_COMBINATIONAL;

end Behavioral;