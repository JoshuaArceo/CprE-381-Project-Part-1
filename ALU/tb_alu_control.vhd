library IEEE;
use IEEE.std_logic_1164.all;

entity tb_alu_control is
 
end tb_alu_control;

architecture mixed of tb_alu_control is

component ALUcontrol is
  port(i_func       : in std_logic_Vector(5 downto 0);
       i_opcode       : in std_logic_Vector(5 downto 0);
       s_out        : out std_logic_Vector(3 downto 0)); 
end component;

signal s_func           : std_logic_vector(5 downto 0);
signal s_opcode           : std_logic_vector(5 downto 0);
signal s_out            : std_logic_vector(3 downto 0);

begin

  DUT0: ALUcontrol
  port map(i_func           => s_s_type,
  i_opcode           => s_opcode,
           s_out            => s_s_out
           );


  P_TEST_CASES: process
  begin

   

  end process;

end mixed;