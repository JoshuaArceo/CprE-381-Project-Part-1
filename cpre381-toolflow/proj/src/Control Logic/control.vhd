library IEEE;
use IEEE.std_logic_1164.all;

entity control is
port( 
	  i_opcode       :   in std_logic_vector(5 downto 0); --bits 31-26 opcode
      i_func         :   in std_logic_vector(5 downto 0);
      o_ALUSrc       :   out std_logic; --use correcty extended immediate from B
      o_MemtoReg     :   out std_logic; -- on 0 does not read from memory
	  o_Shift          :   out std_logic;
      o_Jal          :   out std_logic;
      o_JR           :   out std_logic;
      o_DMemWr       :   out std_logic; --memwrite from text, on 0 does not write to memory
      o_RegWr        :   out std_logic; --Regwrite from text, on 1 writes back to a register
	  o_Jump	     :   out std_logic;
	  o_Branch	     :   out std_logic;
	  o_BNE			 :   out std_logic;
	  o_Halt	     :   out std_logic;
      o_RegDst       :   out std_logic;  --uses rt as destination register rather than rd
	  o_SignExt	     :   out std_logic
	  );

end control;

architecture behavioral of control is

begin


process(i_opcode, i_func) 
  begin
	o_ALUSrc 	<= '0';
	o_MemtoReg 	<= '0';
	o_Shift		<= '0';
	o_Jal 		<= '0';
	o_JR 		<= '0';
	o_DMemWr 	<= '0';
	o_RegWr 	<= '0';
	o_Jump 		<= '0';
	o_Branch 	<= '0';
	o_BNE 		<= '0';
	o_Halt      <= '0';
	o_RegDst 	<= '0';
	o_SignExt 	<= '0';

    if(i_opcode = "010100") then
		o_Halt <= '1'; 
	elsif(i_opcode = "000000") then --R type value 
		if(i_func = "001000") then --jr
			o_JR 		<= '1';
		elsif(i_func = "101010" or i_func = "100010" or i_func = "100011") then --slt or sub or subu
			o_RegWr <= '1';
			o_RegDst <= '1';
		elsif(i_func = "000000" or i_func = "000010"or i_func = "000011") then --sll | srl | sra
			o_ALUSrc <= '1';
			o_RegWr <= '1';
			o_RegDst <= '1';
			o_Shift <= '1';				
		--other
		else
			o_RegWr <= '1';
			o_RegDst <= '1';
		end if;

	elsif (i_opcode = "000010") then --j 
	o_ALUSrc <= '1';
	o_Jump <= '1';
	o_Branch <= '1';

	elsif (i_opcode = "000011") then --jal 
	o_ALUSrc <= '1';
	o_Jal <= '1';
	o_RegWr <= '1';
	o_Jump <= '1';

	elsif (i_opcode = "000100") then --beq 
	o_signExt <= '1';
	o_Branch <= '1';
	
	elsif (i_opcode = "000101") then --bne 
	-- o_Branch <= '1';
	o_signExt <= '1';
	o_BNE	 <= '1';

    elsif (i_opcode = "001000") then --addi 
	o_ALUSrc <= '1';
	o_RegWr <= '1';
	o_signExt <= '1';
    
    elsif (i_opcode = "001001") then --addiu 
	o_ALUSrc <= '1';
	o_RegWr <= '1';
	o_signExt <= '1';


	elsif (i_opcode = "001010") then --slti 
	o_signExt <= '1';
	o_ALUSrc <= '1';
	o_RegWr <= '1';

	elsif (i_opcode = "001100") then --andi 
	o_ALUSrc <= '1';
	o_RegWr <= '1';
    
	elsif (i_opcode = "001101") then --ori 
	o_ALUSrc <= '1';
	o_RegWr <= '1';
	
	elsif (i_opcode = "001110") then --xori 
	o_ALUSrc <= '1';
	o_RegWr <= '1';

	elsif (i_opcode = "001111") then --lui 
	o_ALUSrc <= '1';
	o_RegWr <= '1';

	elsif (i_opcode = "100011") then --lw 
	o_signExt <= '1';
	o_ALUSrc <= '1';
	o_MemtoReg <= '1';
	o_RegWr <= '1';

    elsif (i_opcode = "101011") then --sw
	o_signExt <= '1';
	o_ALUSrc <= '1';
	o_DMemWr <= '1';
	

end if;

 end process;

end behavioral;