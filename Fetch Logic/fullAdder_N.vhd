library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder_N is
  generic(N : integer := 32); 
  port(i_A1              : in std_logic_vector(N-1 downto 0);
       i_B1              : in std_logic_vector(N-1 downto 0);
       i_C1              : in std_logic;
       o_S1              : out std_logic_vector(N-1 downto 0);
       o_C1              : out std_logic);

end fullAdder_N;

architecture structural of fullAdder_N is

  component fullAdder is
    port(i_A1            : in std_logic;
       i_B1              : in std_logic;
       i_C1              : in std_logic;
       o_S1              : out std_logic;
       o_C1              : out std_logic);
  end component;

signal t :   std_logic_vector(N-1 downto 1);
constant c:  INTEGER := N-1;

begin

    C1: fullAdder port map(
              	i_A1      => i_A1(0),    
              	i_B1      => i_B1(0), 
              	i_C1      => i_C1, 
              	o_S1      => o_S1(0),
 	      	o_C1      => t(1)
	); 
    C2: for i in 1 to N-2 generate
    	ADDI: fullAdder port map(
              	i_A1      => i_A1(i),    
              	i_B1      => i_B1(i), 
              	i_C1      => t(i), 
              	o_S1      => o_S1(i),
 	      	o_C1      => t(i+1)
	); 
	end generate;
    C3: fullAdder port map(
              	i_A1      => i_A1(c),    
              	i_B1      => i_B1(c), 
              	i_C1      => t(c), 
              	o_S1      => o_S1(c),
 	      	o_C1      => o_C1
	); 
  
end structural;