library IEEE;
use IEEE.std_logic_1164.all;

entity ripple_adder_N is 
	generic(N : integer := 32);
	port(i_A	: in std_logic_vector(N-1 downto 0);
	     i_B	: in std_logic_vector(N-1 downto 0);
	     i_Cin	: in std_logic;
	     o_S	: out std_logic_vector(N-1 downto 0);
		 o_OFCIN: out std_logic;
	     o_Cout	: out std_logic);
end ripple_adder_N;

architecture structure of ripple_adder_N is 
	component full_adder is
		port(
		     i_A	: in std_logic;
		     i_B	: in std_logic;
		     i_Cin	: in std_logic;
		     o_S	: out std_logic;
		     o_Cout	: out std_logic);
	end component;

	signal s_Cin : std_logic_vector(N downto 0);

begin 

s_Cin(0) <= i_Cin;

G_NBit_Adders: for i in 0 to N-1 generate
	adder: full_adder
	port map(
		i_A	=>i_A(i),
		i_B	=>i_B(i),
		i_Cin	=>s_Cin(i),
		o_S	=>o_S(i),
		o_Cout	=>s_Cin(i+1));
end generate G_NBit_Adders;

o_OFCIN <= s_Cin(N-1);

o_Cout <= s_Cin(N);

end structure;
