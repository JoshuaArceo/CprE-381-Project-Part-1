library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity alu is 
    generic(N : integer := 32);        
    port (
        i_OP_A      : in    std_logic_vector(N-1 downto 0);
        i_OP_B      : in    std_logic_vector(N-1 downto 0);
        i_ALUOP     : in    std_logic_vector(3 downto 0); -- 4 bit to support 13 functions
        o_F         : out   std_logic_vector(N-1 downto 0);
        o_C_OUT     : out   std_logic;
        o_OVERFLOW  : out   std_logic;
        o_ZERO      : out std_logic
        );
end alu;

\*
0000 and *
0001 or *
0010 add/addi *
0011 addu
0100 addiu
0101 xor
0110 sub *
0111 slt *

1000 subu
1001 sll
1010 srl
1011 sra
1100 repl.qb
1101 nor
1110
1111    
*\

architecture structural of alu is

    component shifter is 
    port(
        i_D     : in    std_logic_vector(N-1 downto 0);
        i_AMT     : in    std_logic_vector(4 downto 0);
        i_DIR   : in    std_logic; -- 1 left , 0 right
        i_ARITH   : in    std_logic; -- 0 logical, 1 arithmetic
        o_Q     : out   std_logic_vector(N-1 downto 0)
    );
    end component;

    component and_32bit is 
    port(
        i_A          : in std_logic_vector(31 downto 0);
        i_B          : in std_logic_vector(31 downto 0);
        o_F          : out std_logic_vector(31 downto 0)
    );
    end component;

    component or_32bit is
        port(
        i_A          : in std_logic_vector(31 downto 0);
        i_B          : in std_logic_vector(31 downto 0);
        o_F          : out std_logic_vector(31 downto 0)
    );
    end component;

    component add_sub_N is
        port(
            i_A	: in std_logic_vector(N-1 downto 0);
            i_B	: in std_logic_vector(N-1 downto 0);
            i_nAdd_Sub	: in std_logic;
            o_S	: out std_logic_vector(N-1 downto 0);
            o_OF: out std_logic;
            o_Cout	: out std_logic
            );
    end component;
    
    signal s_adder, s_shifter, s_and, s_or, s_out : std_logic_vector(31 downto 0);
    signal s_add_sub, s_cout, s_overflow, s_zero : std_logic;
    
    begin 

    and32: and_32bit 
    port map(
        i_A => i_OP_A,
        i_B => i_OP_B,
        o_F => s_and
    );

    or32: or_32bit 
    port map(
        i_A => i_OP_A,
        i_B => i_OP_B,
        o_F => s_or
    );

    addSub: add_sub_N
    port map(
        i_A => i_OP_A,
        i_B => i_OP_B,
        i_nAdd_Sub => s_add_sub,
        o_S => s_adder,
        o_OF => s_overflow
        o_Cout => s_cout
    );



    o_C_out <= '0';


    if(i_ALUOP = "0000") then
        s_out <= s_and;
    elsif(i_ALUOP = "0001") then
        s_out <= s_or;
    elsif(i_ALUOP = "0010") then
        s_add_sub <= 0;
        s_out <= s_adder;
    end if;
    

    if(s_out = X"00000000") then 
        s_zero = '1'
    end if;
    


    o_F <= s_out;
    o_C_OUT <= s_cout;
    o_OVERFLOW  <= s_overflow;
    o_ZERO  <= s_zero;



end mixed;
