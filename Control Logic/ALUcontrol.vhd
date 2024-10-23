library IEEE;
use IEEE.std_logic_1164.all;

entity ALUcontrol is
  port(s_type       : in std_logic_Vector(5 downto 0);
       opcode       : in std_logic_Vector(5 downto 0);
       s_out        : out std_logic_Vector(3 downto 0)
	   );   

end ALUcontrol;

architecture structural of ALUcontrol is

signal temp : std_logic_vector(3 downto 0);

begin

process(s_type, opcode)
begin

if (opcode = "000000") then
	if (s_type = "000000") then--sll
		temp <= "1001";
	elsif (s_type = "000010") then--srl
		temp <= "1010";
	elsif (s_type = "000011") then--sra
		temp <= "1011";
	elsif (s_type = "100000") then--add
		temp <= "0010";
	elsif (s_type = "100001") then--addu
		temp <= "0100";
	elsif (s_type = "100100") then--and
		temp <= "0000";
	elsif (s_type = "001000") then--jr
		temp <= "0110";
	elsif (s_type = "100111") then--nor
		temp <= "1101";
	elsif (s_type = "100101") then--or
		temp <= "0001";
	elsif (s_type = "101010") then--slt
		temp <= "0111";
	elsif (s_type = "100010") then--sub
		temp <= "0110";
	elsif (s_type = "100011") then--subu
		temp <= "1000";
	elsif (s_type = "100110") then--xor
		temp <= "0101";
	end if;

elsif (opcode(5 downto 2) = "0001") then
	if (opcode = "000100") then
		temp <= "1101";
	elsif (opcode = "000101") then
		temp <= "1110";
	end if;

elsif (opcode(5 downto 2) = "0010") then
	if (opcode = "001000") then
		temp <= "1111";
	elsif (opcode = "001001") then
		temp <= "0000";
	elsif (opcode = "001010") then
		temp <= "0001";
	end if;

elsif (opcode(5 downto 2) = "0011") then
	if (opcode = "001100") then
		temp <= "0010";
	elsif (opcode = "001101") then
		temp <= "0011";
	elsif (opcode = "001110") then
		temp <= "0100";
	elsif (opcode = "001111") then
		temp <= "0101";
	end if;

elsif (opcode(5 downto 2) = "1000") then
	if (opcode = "100011") then
		temp <= "0110";
	end if;

elsif (opcode(5 downto 2) = "1010") then
	if (opcode = "101011") then
		temp <= "0111";
	end if;
elsif (opcode(5 downto 0) = "000011") then
		temp <= "1000";
else
	temp <= "1111";

end if;
end process;  
s_out <= temp;
end structural;