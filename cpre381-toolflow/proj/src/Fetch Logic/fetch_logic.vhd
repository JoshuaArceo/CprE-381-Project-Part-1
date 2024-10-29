library IEEE;
use IEEE.std_logic_1164.ALL;

entity fetch_logic is
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

end fetch_logic;

architecture structural of fetch_logic is

    component mux2t1_N is
        generic(N : integer := 32);
        port (
            i_S  : in std_logic;
            i_D0 : in std_logic_vector(N - 1 downto 0);
            i_D1 : in std_logic_vector(N - 1 downto 0);
            o_O  : out std_logic_vector(N - 1 downto 0)
            );
    end component;

    component shifter is
        port(
        i_D       : in    std_logic_vector(N-1 downto 0);
        i_AMT     : in    std_logic_vector(4 downto 0);
        i_DIR     : in    std_logic; -- 1 left , 0 right
        i_ARITH   : in    std_logic; -- 0 logical, 1 arithmetic
        o_Q       : out   std_logic_vector(N-1 downto 0)
    );
    end component;

    component ripple_adder_N is
        port(
         i_A	: in std_logic_vector(N-1 downto 0);
	     i_B	: in std_logic_vector(N-1 downto 0);
	     i_Cin	: in std_logic;
	     o_S	: out std_logic_vector(N-1 downto 0);
		 o_OFCIN: out std_logic;
	     o_Cout	: out std_logic);
    end component;
    
    component andg2 is
        port(
        i_A          : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic
        );
    end component;

    component org2 is
        port(
        i_A          : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic
        );
    end component;

    component invg is
        port(
            i_A : in std_logic;
            o_F : out std_logic
        );
    end component;


    signal s_PC4, s_shifted_imm, s_branch_addr, s_jumpAddr, s_branchOut, s_jrOut : std_logic_vector(N-1 downto 0); 
    signal s_BranchSelect, s_BranchZero, s_BNEZero, s_not_ALU_Zero  : std_logic;

begin

    PC_Add4 : ripple_adder_N
    port map(
        i_A => i_PC, 
        i_B => X"00000004",
        i_Cin => '0',
        o_S => s_PC4
    );

    o_PC4 <= s_PC4;
    s_jumpAddr <= s_PC4(31 downto 28) & i_JAddr & "00";

    Branch_Shifter : shifter
    port map(
        i_D                => i_imm,
        i_AMT              => "00010",     
        i_DIR              => '1',    
        i_ARITH            => '0', 
        o_Q                => s_shifted_imm
    );

    Branch_PC_Adder : ripple_adder_N
    port map(
        i_A => s_PC4,
        i_B => s_shifted_imm,
        i_Cin => '0',
        o_S => s_branch_addr
    );

    beqAnd : andg2
    port map(
        i_A => i_Branch,
        i_B => i_ALU_Zero,
        o_F => s_BranchZero
    );

    notALU_Zero : invg
    port map(
        i_A => i_ALU_Zero,
        o_F => s_not_ALU_Zero
    );

    bneAnd : andg2
        port map(
        i_A => i_BNE,
        i_B => s_not_ALU_Zero,
        o_F => s_BNEZero
    );
    
    branchOr : org2
    port map(
        i_A => s_BranchZero,
        i_B => s_BNEZero,
        o_F => s_BranchSelect
    );

    jrBranch : mux2t1_N
    port map(
        i_S => i_JR,
        i_D0 => s_PC4,
        i_D1 => i_RegA,
        o_O => s_jrOut
    );

    branchMux: mux2t1_N
    port map(
        i_S  => s_BranchSelect,
        i_D0 => s_jrOut,
        i_D1 => s_branch_addr,
        o_O  => s_branchOut
    );

    outMux : mux2t1_N
    port map(
        i_S => i_Jump,
        i_D0 => s_branchOut,
        i_D1 => s_jumpAddr,
        o_O => o_PC
    );



END structural;
