library IEEE;
use IEEE.std_logic_1164.all;

entity tb_alu_control is
 
end tb_alu_control;

architecture mixed of tb_alu_control is

component ALUcontrol is
  port(s_type       : in std_logic_Vector(5 downto 0);
       opcode       : in std_logic_Vector(5 downto 0);
       s_out        : out std_logic_Vector(3 downto 0)); 
end component;

signal s_s_type           : std_logic_vector(5 downto 0);
signal s_opcode           : std_logic_vector(5 downto 0);
signal s_s_out            : std_logic_vector(3 downto 0);

begin

  DUT0: ALUcontrol
  port map(s_type           => s_s_type,
           opcode           => s_opcode,
           s_out            => s_s_out
           );


  P_TEST_CASES: process
  begin

    -- Test R type
    s_s_type              <= "000000";  -- expect: 0000
    s_opcode              <= "000000";
    wait for 100 ns;

    s_s_type              <= "000010";  -- expect: 0001
    s_opcode              <= "000000";
    wait for 100 ns;

    s_s_type              <= "100100";  -- expect: 0101
    s_opcode              <= "000000";
    wait for 100 ns;

    s_s_type              <= "100111";  -- expect: 0111
    s_opcode              <= "000000";
    wait for 100 ns;
    -- end R type

    s_s_type              <= "000000";  -- expect: 1101
    s_opcode              <= "000100";
    wait for 100 ns;

    s_s_type              <= "000000";  -- expect: 1111
    s_opcode              <= "001000";
    wait for 100 ns;

    s_s_type              <= "000000";  -- expect: 0011
    s_opcode              <= "001101";
    wait for 100 ns;

    s_s_type              <= "000000";  -- expect: 0101
    s_opcode              <= "001111";
    wait for 100 ns;

    s_s_type              <= "000000";  -- expect: 0110
    s_opcode              <= "100011";
    wait for 100 ns;

    s_s_type              <= "000000";  -- expect: 0111
    s_opcode              <= "101011";
    wait for 100 ns;

    s_s_type              <= "000000";  -- expect: 1111
    s_opcode              <= "111111";
    wait for 100 ns;

  end process;

end mixed;