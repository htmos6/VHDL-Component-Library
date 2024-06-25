library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_nbitfulladder is
end test_nbitfulladder;

architecture Behavioral of test_nbitfulladder is

    -- Component declaration of the unit under test (UUT)
    component NbitFullAdder
        generic (
            N : integer := 8
        );
        port (
            a_i     : in  std_logic_vector (N-1 downto 0);
            b_i     : in  std_logic_vector (N-1 downto 0);
            carry_i : in  std_logic;
            out_o   : out std_logic_vector (N-1 downto 0);
            carry_o : out std_logic
        );
    end component;

    -- Signals to connect to the UUT
    signal a_i     : std_logic_vector(7 downto 0) := (others => '0');
    signal b_i     : std_logic_vector(7 downto 0) := (others => '0');
    signal carry_i : std_logic := '0';
    signal out_o   : std_logic_vector(7 downto 0);
    signal carry_o : std_logic;

begin

    -- Instantiate the UUT
    uut: NbitFullAdder
        generic map (
            N => 8
        )
        port map (
            a_i     => a_i,
            b_i     => b_i,
            carry_i => carry_i,
            out_o   => out_o,
            carry_o => carry_o
        );

    -- Stimulus process to apply test vectors
    stim_proc: process
    begin
        -- Test case 1: 0 + 0 + 0
        a_i <= "00000000"; b_i <= "00000000"; carry_i <= '0';
        wait for 10 ns;
        assert (out_o = "00000000" and carry_o = '0') report "Test case 1 failed" severity error;

        -- Test case 2: 1 + 1 + 0
        a_i <= "00000001"; b_i <= "00000001"; carry_i <= '0';
        wait for 10 ns;
        assert (out_o = "00000010" and carry_o = '0') report "Test case 2 failed" severity error;

        -- Test case 3: 1 + 1 + 1
        a_i <= "00000001"; b_i <= "00000001"; carry_i <= '1';
        wait for 10 ns;
        assert (out_o = "00000011" and carry_o = '0') report "Test case 3 failed" severity error;

        -- Test case 4: 255 + 1 + 0
        a_i <= "11111111"; b_i <= "00000001"; carry_i <= '0';
        wait for 10 ns;
        assert (out_o = "00000000" and carry_o = '1') report "Test case 4 failed" severity error;

        -- Test case 5: 128 + 128 + 1
        a_i <= "10000000"; b_i <= "10000000"; carry_i <= '1';
        wait for 10 ns;
        assert (out_o = "00000001" and carry_o = '1') report "Test case 5 failed" severity error;

        -- Test case 6: 85 + 170 + 0
        a_i <= "01010101"; b_i <= "10101010"; carry_i <= '0';
        wait for 10 ns;
        assert (out_o = "11111111" and carry_o = '0') report "Test case 6 failed" severity error;

        -- Test case 7: 85 + 170 + 1
        a_i <= "01010101"; b_i <= "10101010"; carry_i <= '1';
        wait for 10 ns;
        assert (out_o = "00000000" and carry_o = '1') report "Test case 7 failed" severity error;

        -- Test case 8: Random values
        a_i <= "00110011"; b_i <= "11001100"; carry_i <= '1';
        wait for 10 ns;
        assert (out_o = "00000000" and carry_o = '1') report "Test case 8 failed" severity error;
		
		-- Test case 9: Random values
        a_i <= "00000011"; b_i <= "00000100"; carry_i <= '0';
        wait for 10 ns;
        assert (out_o = "00000111" and carry_o = '0') report "Test case 9 failed" severity error;
		
		-- Test case 10: Random values
        a_i <= "00110000"; b_i <= "00001100"; carry_i <= '0';
        wait for 10 ns;
        assert (out_o = "00111100" and carry_o = '0') report "Test case 10 failed" severity error;

        -- End simulation
        wait;
    end process stim_proc;

end Behavioral;
