library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity tb_alu_with_control is
end tb_alu_with_control;


architecture mixed of tb_alu_with_control is
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

component ALUcontrol is
        port(i_func       : in std_logic_Vector(5 downto 0);
             i_opcode       : in std_logic_Vector(5 downto 0);
             s_out        : out std_logic_Vector(3 downto 0)); 
end component;

signal s_func, s_opcode : std_logic_vector(5 downto 0);

signal s_iA, s_iB,  s_oF : std_logic_vector(31 downto 0);
signal s_iALUOP : std_logic_vector(3 downto 0);
signal s_oCOUT, s_oOVERFLOW, s_oZERO : std_logic;

begin

DUT0: ALUcontrol
port map(
    i_func => s_func,
    i_opcode => s_opcode,
    s_out => s_iALUOP
);

DUT1: alu
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
    s_iA <= X"0000FFFF";
    s_iB <= X"FFFF0000";
    s_opcode <= "000000";
    s_func <= "100100";
    wait for 10ns;

end process;
end mixed;