library IEEE;
use IEEE.std_logic_1164.all;

entity ALUcontrol is
  port(i_func       : in std_logic_Vector(5 downto 0);
       i_opcode       : in std_logic_Vector(5 downto 0);
       s_out        : out std_logic_Vector(3 downto 0)
	   );   

end ALUcontrol;

architecture structural of ALUcontrol is

signal temp : std_logic_vector(3 downto 0);

begin

process(i_func, i_opcode)
begin

if (i_opcode = "000000") then
	if (i_func = "000000") then--sll
		temp <= "1001";
	elsif (i_func = "000010") then--srl
		temp <= "1010";
	elsif (i_func = "000011") then--sra
		temp <= "1011";
	elsif (i_func = "100000") then--add
		temp <= "0010";
	elsif (i_func = "100001") then--addu
		temp <= "0100";
	elsif (i_func = "100100") then--and
		temp <= "0000";
	elsif (i_func = "001000") then--jr
		temp <= "0110";
	elsif (i_func = "100111") then--nor
		temp <= "1101";
	elsif (i_func = "100101") then--or
		temp <= "0001";
	elsif (i_func = "101010") then--slt
		temp <= "0111";
	elsif (i_func = "100010") then--sub
		temp <= "0110";
	elsif (i_func = "100011") then--subu
		temp <= "1000";
	elsif (i_func = "100110") then--xor
		temp <= "0101";
	end if;

elsif (i_opcode(5 downto 2) = "0001") then
		temp <= "0110"; --subtract for beq and bne

elsif (i_opcode(5 downto 2) = "0010") then
	if (i_opcode = "001000") then
		temp <= "0010"; --addi
	elsif (i_opcode = "001001") then
		temp <= "0011";  --addiu
	elsif (i_opcode = "001010") then
		temp <= "0111"; --slti
	end if;

elsif (i_opcode(5 downto 2) = "0011") then
	if (i_opcode = "001100") then
		temp <= "0000"; --andi
	elsif (i_opcode = "001101") then
		temp <= "0001"; --ori
	elsif (i_opcode = "001110") then
		temp <= "0101"; --xori
	elsif (i_opcode = "001111") then
		temp <= "0100"; --lui
	end if;

elsif (i_opcode(5 downto 2) = "1000") then
	if (i_opcode = "100011") then --lw
		temp <= "0010"; 
	end if;

elsif (i_opcode(5 downto 2) = "1010") then
	if (i_opcode = "101011") then --sw
		temp <= "0010"; 
	end if;
else
	temp <= "1111";
end if;
end process;  
s_out <= temp;
end structural;