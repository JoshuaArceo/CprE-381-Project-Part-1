library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity tb_alu is
end tb_alu;


architecture mixed of tb_alu is

component alu is
    generic(N : integer := 32); 
    port(
        i_OP_A      : in    std_logic_vector(N-1 downto 0);
        i_OP_B      : in    std_logic_vector(N-1 downto 0);
        i_ALUCTRL     : in    std_logic_vector(3 downto 0); -- 4 bit to support 13 functions
        o_F         : out   std_logic_vector(N-1 downto 0);
        o_C_OUT     : out   std_logic;
        o_OVERFLOW  : out   std_logic;
        o_ZERO      : out std_logic
    );
end component;

signal s_iA, s_iB,  s_oF : std_logic_vector(31 downto 0);
signal s_iALUOP : std_logic_vector(3 downto 0);
signal s_oCOUT, s_oOVERFLOW, s_oZERO : std_logic;

begin

DUT0: alu
port map(
    i_OP_A => s_iA,
    i_OP_B => s_iB,
    i_ALUCTRL => s_iALUOP,
    o_F => s_oF,
    o_C_OUT => s_oCOUT,
    o_OVERFLOW => s_oOVERFLOW,
    o_ZERO => s_oZERO
);


P_TEST_CASES: process
begin
    --and
    report "And";
    s_iALUOP <= "0000";
    s_iA <= X"0000FFFF";
    s_iB <= X"FFFF0000";
    wait for 10 ns;

    s_iB <= X"FFFFABCD";
    wait for 10ns;

    --or
    report "Or";
    s_iALUOP <= "0001";
    
    s_iA <= X"0000FFFF";
    s_iB <= X"FFFF0000";
    wait for 10ns;

    s_iB <= X"00000000";
    wait for 10ns;

    --add/addi (can be tested the same way since the immediate value selection is done OUTSIDE of the ALU and inputted into B)
    report "add/addi";
    s_iALUOP <= "0010";
    
    s_iA <= X"7FFFFFFF";  
    s_iB <= X"00000001"; 
    wait for 10ns;

    s_iA <= X"11111111";
    s_iB <= X"22222222";
    wait for 10ns;

    --addu/addiu
    report "addu/addiu";
    s_iALUOP <= "0011";
    s_iA <= X"7FFFFFFF";  
    s_iB <= X"FFFFFFFF"; 
    wait for 10ns;

    s_iA <= X"11111111";
    s_iB <= X"22222222";
    wait for 10ns;

    --xor
    report "xor";
    s_iALUOP <= "0101";

    s_iA <= "10101111000010101010111100001010";
    s_iB <= "01011100001101110011001101011000";
    wait for 10ns;

    --sub
    report "sub";
    s_iALUOP <= "0110";

    s_iA <= X"7FFFFFFF";  
    s_iB <= X"FFFFFFFF"; 
    wait for 10ns;

    s_iA <= X"7ABCDEF0";  
    s_iB <= X"7ABCDEF0";
    wait for 10ns;

    --slt
    report "slt";
    s_iALUOP <= "0111";
    
    s_iA <= X"7ABCDEF0";  
    s_iB <= X"7ABCDEF0";
    wait for 10ns;

    s_iA <= X"00000000";
    s_iB <= X"00000001";
    wait for 10ns;
    
    s_iA <= X"00000001";
    s_iB <= X"00000000";
    wait for 10ns;

    s_iA <= X"F00DBEEF";
    s_iB <= X"ABCDEF01";
    wait for 10ns;

    --subu
    report "subu";
    s_iALUOP <= "1000";

    s_iA <= X"7FFFFFFF";  
    s_iB <= X"FFFFFFFF"; 
    wait for 10ns;

    s_iA <= X"7ABCDEF0";  
    s_iB <= X"7ABCDEF0";
    wait for 10ns;

    --sll
    report "sll";
    s_iALUOP <= "1001";
    s_iA <= "00000000000000000000000011111111";
   
    s_iB <= (4 downto 0 => "00001" , others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 =>  "00011", others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 => "10100", others => '0');
     wait for 10ns;
    s_iA <= "11111111000000000000000011111111";
    
    s_iB <= (4 downto 0 => "00001" , others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 =>  "00011", others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 => "10100", others => '0');
     wait for 10ns;

    --srl
    report "srl";
    s_iALUOP <= "1010";
    s_iA <= "00000000000000000000000011111111";
   
    s_iB <= (4 downto 0 => "00001" , others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 =>  "00011", others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 => "10100", others => '0');
     wait for 10ns;
    
    s_iA <= "11111111000000000000000011111111";
    
    s_iB <= (4 downto 0 => "00001" , others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 =>  "00011", others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 => "10100", others => '0');
     wait for 10ns;

     --sra
     report "sra";
     s_iALUOP <= "1011";

     s_iB <= (4 downto 0 => "00001" , others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 =>  "00011", others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 => "10100", others => '0');
     wait for 10ns;

     
     s_iA <= "11111111000000000000000011111111";

     s_iB <= (4 downto 0 => "00001" , others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 =>  "00011", others => '0');
     wait for 10ns;

     s_iB <= (4 downto 0 => "10100", others => '0');
     wait for 10ns;

     --repl.qb
     report "replicate";
     s_iALUOP <= "1100";
     s_iA <= X"ABCDEF10";

     s_iB <= (1 downto 0 => "00", others => '0');
     wait for 10ns;

     s_iB <= (1 downto 0 => "01", others => '0');
     wait for 10ns;

     s_iB <= (1 downto 0 => "10", others => '0');
     wait for 10ns;

     s_iB <= (1 downto 0 => "11", others => '0');
    wait for 10ns;

    --nor
    report "nor";
    s_iALUOP <= "1101";
    s_iA <= X"0000FFFF";
    s_iB <= X"FFFF0000";
    wait for 10ns;

    s_iB <= X"00000000";
    wait for 10ns;
    report "end";
 

     end process;

end mixed;