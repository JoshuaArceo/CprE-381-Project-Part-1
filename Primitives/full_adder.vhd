library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder is
	port(i_A	: in std_logic;
	     i_B	: in std_logic;
	     i_Cin	: in std_logic;
	     o_S	: out std_logic;
	     o_Cout	: out std_logic);
end full_adder;

architecture structure of full_adder is
	component andg2 is
		port(i_A          : in std_logic;
		     i_B	  : in std_logic;       		     
		     o_F          : out std_logic);
	end component;
	
	component org2 is
		port(i_A          : in std_logic;
		     i_B	  : in std_logic;       		     
		     o_F          : out std_logic);
	end component;

	component xorg2 is
		port(i_A          : in std_logic;
		     i_B	  : in std_logic;       		     
		     o_F          : out std_logic);
	end component;
--SIGNALS HERE
	signal s_X, s_Y, s_Z	: std_logic;

begin

	xor1: xorg2
	port MAP(i_A => i_A,
		 i_B => i_B,
		 o_F => s_X);

	xor2: xorg2
	port MAP(i_A => s_X,
		 i_B => i_Cin,
		 o_F => o_S);

	and1: andg2
	port MAP(i_A => i_A,
		 i_B => i_B,
		 o_F => s_Y);

	and2: andg2
	port MAP(i_A => s_X,
		 i_B => i_Cin,
		 o_F => s_Z);
	
	or1: org2
	port MAP(i_A => s_Y,
		 i_B => s_Z,
		 o_F => o_Cout);

end structure; 

