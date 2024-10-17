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

1000 subiu
1001 sll
1010 srl
1011 sra
1100 repl.qb
1101 nor
1110
1111    
*\

architecture mixed of alu is

    component 




end mixed;
