library IEEE;
use IEEE.std_logic_1164.all;

entity control is
port( readIn       :   in std_logic_vector(5 downto 0); --bits 31-26 opcode
      jrCode       :   in std_logic_vector(5 downto 0);
      ALUControl   :   out std_logic_vector(5 downto 0); --0010 will perform add of A and B
      ALUSrc       :   out std_logic; --use correcty extended immediate from B
      MemtoReg     :   out std_logic; -- on 0 does not read from memory
      jalSig       :   out std_logic;
      jrSig        :   out std_logic;
      s_DMemWr     :   out std_logic; --memwrite from text, on 0 does not write to memory
      s_RegWr      :   out std_logic; --Regwrite from text, on 1 writes back to a register
	  Jump	       :   out std_logic;
	  Branch	   :   out std_logic;
	  s_Halt	   :   out std_logic;
      RegDst       :   out std_logic;  --uses rt as destination register rather than rd
	  signExt	   :   out std_logic 
	  );

end control;

architecture behavioral of control is

begin


P1: process(readIn) 
  begin
    if (readIn = "000000") then --R type value 
	if(jrCode = "001000") then --jr
		ALUControl <= readIn(5 downto 0);
		ALUSrc <= '0';
		MemtoReg <= '0';
		jalSig <= '0';
		jrSig <= '1';
		s_DMemWr <= '0';
		s_RegWr <= '0';
		RegDst <= '0';
		Jump <= '1';
		Branch <= '0';
		s_Halt <= '0';
		signExt <= '0';
	else --other
		ALUControl <= readIn(5 downto 0);
		ALUSrc <= '0';
		MemtoReg <= '0';
		jalSig <= '0';
		jrSig <= '0';
		s_DMemWr <= '0';
		s_RegWr <= '1';
		RegDst <= '1';
		Jump <= '0';
		Branch <= '0';
		s_Halt <= '0';
		signExt <= '0';
	end if;
    
    elsif (readIn = "001000") then --addi 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '1';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '1';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '0';
	s_Halt <= '0';
	signExt <= '1';
    
    elsif (readIn = "001001") then --addiu 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '1';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '1';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '0';
	s_Halt <= '0';
	signExt <= '1';
    
    elsif (readIn = "101011") then --sw
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '1';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '1';
	s_RegWr <= '0';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '0';
	s_Halt <= '0';
	signExt <= '0';
    
    elsif (readIn = "001100") then --andi 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '1';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '1';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '0';
	s_Halt <= '0';
	signExt <= '0';
    
elsif (readIn = "001111") then --lui 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '1';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '1';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '0';
	s_Halt <= '0';
	signExt <= '0';
    
elsif (readIn = "100011") then --lw 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '1';
	MemtoReg <= '1';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '1';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '0';
	s_Halt <= '0';
	signExt <= '0';
    
elsif (readIn = "001110") then --xori 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '1';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '1';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '0';
	s_Halt <= '0';
	signExt <= '0';

elsif (readIn = "001101") then --ori 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '1';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '1';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '0';
	s_Halt <= '0';
	signExt <= '0';
    
elsif (readIn = "001010") then --slti 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '1';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '1';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '0';
	s_Halt <= '0';
	signExt <= '0';
    
elsif (readIn = "000100") then --beq 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '0';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '0';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '1';
	s_Halt <= '0';
	signExt <= '0';
    
elsif (readIn = "000101") then --bne 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '0';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '0';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '1';
	s_Halt <= '0';
	signExt <= '0';
    
elsif (readIn = "000010") then --j 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '1';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '0';
	RegDst <= '0';
	Jump <= '1';
	Branch <= '1';
	s_Halt <= '0';
	signExt <= '0';

elsif (readIn = "000011") then --jal 
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '1';
	MemtoReg <= '0';
	jalSig <= '1';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '1';
	RegDst <= '0';
	Jump <= '1';
	Branch <= '0';
	s_Halt <= '0';
	signExt <= '0';

elsif (readIn = "010100") then --halt(stops)
	ALUControl <= readIn(5 downto 0);
	ALUSrc <= '0';
	MemtoReg <= '0';
	jalSig <= '0';
	jrSig <= '0';
	s_DMemWr <= '0';
	s_RegWr <= '0';
	RegDst <= '0';
	Jump <= '0';
	Branch <= '0';
	s_Halt <= '1';
	signExt <= '0';

end if;

 end process;

end behavioral;