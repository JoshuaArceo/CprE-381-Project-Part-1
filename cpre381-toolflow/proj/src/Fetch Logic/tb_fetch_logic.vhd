library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_fetch_logic is
end tb_fetch_logic;

architecture mixed of tb_fetch_logic is
    -- Constants
    constant N : integer := 32;

    -- Component Declaration
    component fetch_logic
        generic (N : INTEGER := 32);
        port (
            i_PC              : in std_logic_vector(N - 1 downto 0);
            i_JAddr           : in std_logic_vector(25 downto 0);
            i_Imm             : in std_logic_vector(N - 1 downto 0);
            i_RegA            : in std_logic_vector(N - 1 downto 0);
            i_Branch          : in std_logic;
            i_ALU_Zero        : in std_logic;
            i_Jump            : in std_logic;
            i_JR              : in std_logic;
            i_BNE             : in std_logic;
            o_PC4             : out std_logic_vector(N - 1 downto 0);
            o_PC              : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    -- Signals to connect to the fetch_logic
    signal s_iPC, s_oPC4, s_oPC : std_logic_vector(N - 1 downto 0);
    signal s_iJAddr : std_logic_vector(25 downto 0);
    signal s_iImm, s_iRegA : std_logic_vector(N - 1 downto 0);
    signal s_iBranch, s_iALU_Zero, s_iJump, s_iJR, s_iBNE : std_logic;

begin
    -- Instantiate fetch_logic
    DUT: fetch_logic
    port map(
        i_PC => s_iPC,
        i_JAddr => s_iJAddr,
        i_Imm => s_iImm,
        i_RegA => s_iRegA,
        i_Branch => s_iBranch,
        i_ALU_Zero => s_iALU_Zero,
        i_Jump => s_iJump,
        i_JR => s_iJR,
        i_BNE => s_iBNE,
        o_PC4 => s_oPC4,
        o_PC => s_oPC
    );

    stimulus: process
    begin
        -- Simple PC Increment
        s_iPC <= X"00000000";
        s_iJAddr <= X"0000000";
        s_iImm <= X"00000000";
        s_iRegA <= X"00000000";
        s_iBranch <= '0';
        s_iALU_Zero <= '0';
        s_iJump <= '0';
        s_iJR <= '0';
        s_iBNE <= '0';
        wait for 10 ns;
        assert s_oPC4 = X"00000004" 
        report "Failed --> PC + 4 Calculation";

        -- Branch with Zero ALU
        s_iPC <= X"00000008";
        s_iImm <= X"00000010";
        s_iBranch <= '1';
        s_iALU_Zero <= '1';
        wait for 10 ns;
        assert s_oPC = X"00000018" 
        report "Failed --> Branch with ALU_Zero";

        -- Jump
        s_iPC <= X"00000020";
        s_iJAddr <= X"0000001";
        s_iJump <= '1';
        wait for 10 ns;
        assert s_oPC = X"00000044" 
        report "Failed --> Jump Address Calculation";

        -- Jump Register (JR)
        s_iJump <= '0';
        s_iJR <= '1';
        s_iRegA <= X"00000040";
        wait for 10 ns;
        assert s_oPC = X"00000040" 
        report "Failed --> Jump Register Address";

        -- Branch Not Equal (BNE)
        s_iBranch <= '0';
        s_iBNE <= '1';
        s_iALU_Zero <= '0';  -- ALU Zero is 0, so BNE should take branch
        s_iPC <= X"00000008";
        s_iImm <= X"00000004";
        wait for 10 ns;
        assert s_oPC = X"00000010" 
        report "Failed --> BNE Taken";

        wait;
    end process stimulus;

end mixed;
