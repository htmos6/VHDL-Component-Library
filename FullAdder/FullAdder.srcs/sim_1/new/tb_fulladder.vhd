library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_fulladder is
end test_fulladder;

architecture Behavioral of test_fulladder is

    -- Component declaration of the unit under test (UUT)
    component FullAdder
        port (
            a_i     : in  std_logic;
            b_i     : in  std_logic;
            carry_i : in  std_logic;
            out_o   : out std_logic;
            carry_o : out std_logic
        );
    end component;

    -- Signals to connect to the UUT
    signal a_i     : std_logic := '0';
    signal b_i     : std_logic := '0';
    signal carry_i : std_logic := '0';
    signal out_o   : std_logic;
    signal carry_o : std_logic;

begin

    -- Instantiate the UUT
    uut: FullAdder
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
        -- Apply test vectors
        a_i <= '0'; b_i <= '0'; carry_i <= '0';
        wait for 10 ns;
        assert (out_o = '0' and carry_o = '0') report "Test case 0+0+0 failed" severity error;

        a_i <= '0'; b_i <= '0'; carry_i <= '1';
        wait for 10 ns;
        assert (out_o = '1' and carry_o = '0') report "Test case 0+0+1 failed" severity error;

        a_i <= '0'; b_i <= '1'; carry_i <= '0';
        wait for 10 ns;
        assert (out_o = '1' and carry_o = '0') report "Test case 0+1+0 failed" severity error;

        a_i <= '0'; b_i <= '1'; carry_i <= '1';
        wait for 10 ns;
        assert (out_o = '0' and carry_o = '1') report "Test case 0+1+1 failed" severity error;

        a_i <= '1'; b_i <= '0'; carry_i <= '0';
        wait for 10 ns;
        assert (out_o = '1' and carry_o = '0') report "Test case 1+0+0 failed" severity error;

        a_i <= '1'; b_i <= '0'; carry_i <= '1';
        wait for 10 ns;
        assert (out_o = '0' and carry_o = '1') report "Test case 1+0+1 failed" severity error;

        a_i <= '1'; b_i <= '1'; carry_i <= '0';
        wait for 10 ns;
        assert (out_o = '0' and carry_o = '1') report "Test case 1+1+0 failed" severity error;

        a_i <= '1'; b_i <= '1'; carry_i <= '1';
        wait for 10 ns;
        assert (out_o = '1' and carry_o = '1') report "Test case 1+1+1 failed" severity error;

        -- End simulation
        wait;
    end process stim_proc;

end Behavioral;
