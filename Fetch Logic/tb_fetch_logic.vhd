library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

ENTITY tb_fetch_logic IS
END tb_fetch_logic;

ARCHITECTURE behavior OF tb_fetch_logic IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT fetch_logic IS
        GENERIC (N : INTEGER := 32);
        PORT (
            i_PC              : in std_logic_vector(N - 1 DOWNTO 0);
            i_branch_to_adder : in std_logic_vector(N - 1 DOWNTO 0);
            i_jump_to_adder   : in std_logic_vector(N - 1 DOWNTO 0);
            i_jr              : in std_logic_vector(N - 1 DOWNTO 0);
            i_jr_to_select    : in std_logic;
            i_branch          : in std_logic;
            i_zero            : in std_logic;
            i_jump            : in std_logic;
            o_PC              : out std_logic_vector(N - 1 DOWNTO 0);
            o_PC_plus_4       : out std_logic_vector(N - 1 downto 0)
        );
    END COMPONENT;

    -- Signals for connecting to the fetch logic
    SIGNAL s_PC              : std_logic_vector(31 DOWNTO 0) := (others => '0');
    SIGNAL s_branch_to_adder : std_logic_vector(31 DOWNTO 0) := (others => '0');
    SIGNAL s_jump_to_adder   : std_logic_vector(31 DOWNTO 0) := (others => '0');
    SIGNAL s_jr              : std_logic_vector(31 DOWNTO 0) := (others => '0');
    SIGNAL s_jr_to_select    : std_logic := '0';
    SIGNAL s_branch          : std_logic := '0';
    SIGNAL s_zero            : std_logic := '0';
    SIGNAL s_jump            : std_logic := '0';
    SIGNAL s_PC_out          : std_logic_vector(31 DOWNTO 0);
    SIGNAL s_PC_plus_4_out   : std_logic_vector(31 DOWNTO 0);

    -- Clock signal
    signal clk : std_logic := '0';
    
    -- Clock period definition
    constant clk_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    UUT: fetch_logic
    GENERIC MAP (N => 32)
    PORT MAP (
        i_PC              => s_PC,
        i_branch_to_adder => s_branch_to_adder,
        i_jump_to_adder   => s_jump_to_adder,
        i_jr              => s_jr,
        i_jr_to_select    => s_jr_to_select,
        i_branch          => s_branch,
        i_zero            => s_zero,
        i_jump            => s_jump,
        o_PC              => s_PC_out,
        o_PC_plus_4       => s_PC_plus_4_out
    );

    -- Clock process to generate clock signal
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Test cases process
    stim_proc: process
    begin
        -- Initialize Inputs
        s_PC              <= x"00000000"; -- Initial PC
        s_branch_to_adder <= x"00000008"; -- Example branch address
        s_jump_to_adder   <= x"00000010"; -- Example jump address
        s_jr              <= x"00000020"; -- Example jump register address
        s_jr_to_select    <= '0';
        s_branch          <= '0';
        s_zero            <= '0';
        s_jump            <= '0';

        wait for 20 ns;  -- Wait for clock cycles

        -- Test Case 1: Normal PC + 4 operation
        s_PC              <= x"00000000"; 
        wait for clk_period;
        assert (s_PC_plus_4_out = x"00000004")
            report "Test Case 1 (PC+4) Failed" severity error;

        -- Test Case 2: Branch taken
        s_branch <= '1';
        s_zero <= '1';  -- Condition met to take the branch
        wait for clk_period;
        assert (s_PC_out = x"0000000C")
            report "Test Case 2 (Branch) Failed" severity error;

        -- Test Case 3: Jump taken
        s_jump <= '1';
        wait for clk_period;
        assert (s_PC_out = x"00000014")
            report "Test Case 3 (Jump) Failed" severity error;

        -- Test Case 4: Jump Register (jr)
        s_jr_to_select <= '1';
        wait for clk_period;
        assert (s_PC_out = x"00000020")
            report "Test Case 4 (JR) Failed" severity error;

        -- Test complete
        wait;
    end process;

END behavior;
