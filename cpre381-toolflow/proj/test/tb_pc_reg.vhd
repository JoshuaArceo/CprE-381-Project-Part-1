library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_pc_reg is
end tb_pc_reg;

architecture behavior of tb_pc_reg is
    -- Generic constant matching the generic size in the pc_reg entity
    constant N : integer := 32;

    -- Signals for the DUT inputs and outputs
    signal i_D   : std_logic_vector(N-1 downto 0) := (others => '0');
    signal i_RST : std_logic := '0';
    signal i_CLK : std_logic := '0';
    signal i_WE  : std_logic := '0';
    signal o_Q   : std_logic_vector(N-1 downto 0);

    -- DUT instantiation
    component pc_reg
        generic (N : integer := 32);
        port (
            i_D   : in std_logic_vector(N-1 downto 0);
            i_RST : in std_logic;
            i_CLK : in std_logic;
            i_WE  : in std_logic;
            o_Q   : out std_logic_vector(N-1 downto 0)
        );
    end component;

begin
    -- Connect DUT
    DUT: pc_reg
        generic map (N => N)
        port map (
            i_D   => i_D,
            i_RST => i_RST,
            i_CLK => i_CLK,
            i_WE  => i_WE,
            o_Q   => o_Q
        );

    -- Clock generation
    clock_process : process
    begin
        i_CLK <= '0';
        wait for 5 ns;
        i_CLK <= '1';
        wait for 5 ns;
    end process clock_process;
    i_WE <= '1';
    i_D <= x"--------";
    -- Test process
    test_process : process
    begin
        -- Test case 1: Reset operation
        i_RST <= '1';
        wait for 10 ns;
        assert o_Q = x"00400000" report "Reset failed!" severity error;
        
        -- Test case 2: Write enable operation
        i_RST <= '1';
        
       
        wait for 10 ns;
        assert o_Q = x"12345678" report "Write failed!" severity error;

        -- Test case 3: Write disable operation (WE = 0)
        i_D <= x"87654321";
        wait for 10 ns;
        assert o_Q = x"12345678" report "Write disable failed!" severity error;

        -- Test case 4: Reset after write
        i_RST <= '1';
        wait for 10 ns;
        assert o_Q = x"00400000" report "Reset after write failed!" severity error;

        -- End of tests
        wait;
    end process test_process;
end behavior;
