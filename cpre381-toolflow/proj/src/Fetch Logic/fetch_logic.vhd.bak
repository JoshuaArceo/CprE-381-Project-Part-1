library IEEE;
use IEEE.std_logic_1164.ALL;

ENTITY fetch_logic is
    GENERIC (N : INTEGER := 32); 
    PORT (
        i_PC              : in std_logic_vector(N - 1 DOWNTO 0); 
        i_branch_to_adder : in std_logic_vector(N - 1 DOWNTO 0); 
        i_jump_to_adder   : in std_logic_vector(N - 1 DOWNTO 0); 
        i_jr              : in std_logic_vector(N - 1 DOWNTO 0); 
        i_jr_to_select    : in STD_LOGIC;                        
        i_branch          : in STD_LOGIC;                        
        i_zero            : in STD_LOGIC;                        
        i_jump            : in STD_LOGIC;                        
        o_PC              : out std_logic_vector(N - 1 DOWNTO 0); 
        o_PC_plus_4       : out std_logic_vector(N - 1 downto 0) 
        );

END fetch_logic;

ARCHITECTURE structural OF fetch_logic is

    COMPONENT mux2t1_N is
        PORT (
            i_S  : in std_logic;
            i_D0 : in std_logic_vector(N - 1 DOWNTO 0);
            i_D1 : in std_logic_vector(N - 1 DOWNTO 0);
            o_O  : out std_logic_vector(N - 1 DOWNTO 0));
    END COMPONENT;

    COMPONENT shifter is
        PORT (
            i_D                : in std_logic_vector(N-1 downto 0);
            i_AMT              : in std_logic_vector(4 downto 0);                          
            i_DIR              : in std_logic;                         
            -- i_CLK              : in std_logic;       
            o_Q                : out std_logic_vector(N-1 downto 0)); 
    END COMPONENT;

    COMPONENT fullAdder_N is
        PORT (
            i_A1        : in std_logic_vector(N-1 downto 0); 
            i_B1        : in std_logic_vector(N-1 downto 0);
            i_C1        : in std_logic;
            o_S1        : out std_logic_vector(N-1 downto 0);
            o_C1        : out STD_LOGIC
        );
    END COMPONENT;

    signal s_PC4                 : std_logic_vector(N-1 downto 0); 
    signal s_branch_addr_shifted : std_logic_vector(N-1 downto 0); 
    signal s_PC_branch           : std_logic_vector(N-1 downto 0); 
    signal s_j_addr_shifted      : std_logic_vector(N-1 downto 0); 
    signal s_PC_j_addr           : std_logic_vector(N-1 downto 0); 
    signal s_PC_or_Branch        : std_logic_vector(N-1 downto 0);
    signal s_PC_or_j             : std_logic_vector(N-1 downto 0); 
    signal s_toBranch            : std_logic;                        

BEGIN

    --PC+4
    PC_Adder : fullAdder_N
    PORT MAP(
        i_A1 => '0', 
        i_B1 => i_PC,
        i_C1 => x"00000004",
        o_C1 => s_PC4
    );
    o_PC4 <= s_PC4;

    --Shift the branch address by 2
    Branch_Shifter : shifter
    PORT MAP(
        i_D                => i_branch_addr,
        i_AMT              => '0',     
        i_DIR              => '0',     
        -- i_CLK              => "00010", 
        o_Q                => s_branch_addr_shifted
    );

    --Add PC+4 + branch address
    Branch_PC_Adder : fullAdder_N
    PORT MAP(
        i_A1 => '0', --no carry
        i_B1 => s_PC4,
        i_C1 => s_branch_addr_shifted,
        o_C1 => s_PC_branch
    );

    Jump_Address_Shift : shifter
    PORT MAP(
        i_D               => i_jump_addr,
        i_AMT             => '0',     
        i_DIR             => '0',     
        -- i_CLK             => "00010", 
        o_Q               => s_j_addr_shifted
    );

    --Jump Address
    s_PC_j_addr <= s_PC4(31 DOWNTO 28) & s_j_addr_shifted(27 DOWNTO 0);

    s_toBranch <= i_branch AND i_zero;

    Branch_Select : mux2t1_N
    PORT MAP(
        i_S  => s_toBranch,
        i_D0 => s_PC4,
        i_D1 => s_PC_branch,
        o_O  => s_PC_or_Branch
    );

    Jump_Select : mux2t1_N
    PORT MAP(
        i_S  => i_jump,
        i_D0 => s_PC_or_Branch,
        i_D1 => s_PC_j_addr,
        o_O  => s_PC_or_j
    );

    JR_Select : mux2t1_N
    PORT MAP(
        i_S  => i_jr_to_select,
        i_D0 => s_PC_or_j,
        i_D1 => i_jr,
        o_O  => o_PC
    );

END structural;
