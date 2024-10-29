library IEEE;
use IEEE.std_logic_1164.all;

entity ALUcontrol is
  port(i_func       : in std_logic_Vector(5 downto 0);
       i_opcode       : in std_logic_Vector(5 downto 0);
       s_out        : out std_logic_Vector(3 downto 0)
	   );   

end ALUcontrol;

architecture structural of ALUcontrol is


begin

process(i_func, i_opcode)
begin

if (i_opcode = "000000") then
	if (i_func = "000000") then--sll
		s_out <= "1001";
	elsif (i_func = "000010") then--srl
		s_out <= "1010";
	elsif (i_func = "000011") then--sra
		s_out <= "1011";
	elsif (i_func = "100000") then--add
		s_out <= "0010";
	elsif (i_func = "100001") then--addu
		s_out <= "0011";
	elsif (i_func = "100100") then--and
		s_out <= "0000";
	elsif (i_func = "001000") then--jr
		s_out <= "0110";
	elsif (i_func = "100111") then--nor
		s_out <= "1101";
	elsif (i_func = "100101") then--or
		s_out <= "0001";
	elsif (i_func = "101010") then--slt
		s_out <= "0111";
	elsif (i_func = "100010") then--sub
		s_out <= "0110";
	elsif (i_func = "100011") then--subu
		s_out <= "1000";
	elsif (i_func = "100110") then--xor
		s_out <= "0101";
	end if;

elsif (i_opcode(5 downto 2) = "0001") then
		s_out <= "0110"; --subtract for beq and bne

elsif (i_opcode(5 downto 2) = "0010") then
	if (i_opcode = "001000") then
		s_out <= "0010"; --addi
	elsif (i_opcode = "001001") then
		s_out <= "0011";  --addiu
	elsif (i_opcode = "001010") then
		s_out <= "0111"; --slti
	end if;

elsif (i_opcode(5 downto 2) = "0011") then
	if (i_opcode = "001100") then
		s_out <= "0000"; --andi
	elsif (i_opcode = "001101") then
		s_out <= "0001"; --ori
	elsif (i_opcode = "001110") then
		s_out <= "0101"; --xori
	elsif (i_opcode = "001111") then
		s_out <= "0100"; --lui
	end if;

elsif (i_opcode(5 downto 2) = "1000") then
	if (i_opcode = "100011") then --lw
		s_out <= "0010"; 
	end if;

elsif (i_opcode(5 downto 2) = "1010") then
	if (i_opcode = "101011") then --sw
		s_out <= "0010"; 
	end if;
else
	s_out <= "1111";
end if;
end process;  
end structural;