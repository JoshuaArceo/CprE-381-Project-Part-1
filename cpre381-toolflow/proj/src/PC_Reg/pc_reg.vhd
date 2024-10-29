library IEEE;
use IEEE.std_logic_1164.all;

entity pc_reg is
	generic(N : integer := 32);
	port(i_D	: in std_logic_vector(N-1 downto 0);
	     i_RST	: in std_logic;
	     i_CLK	: in std_logic;
	     i_WE	: in std_logic;
	     o_Q	: out std_logic_vector(N-1 downto 0));
end pc_reg;

architecture structural of pc_reg is
	
	component dffg is
		port(
				i_CLK        : in std_logic;     -- Clock input
       		     i_RST        : in std_logic;     -- Reset input
       		     i_WE         : in std_logic;     -- Write enable input
       		     i_D          : in std_logic;     -- Data value input
       		     o_Q          : out std_logic);   -- Data value output
	end component;

	component pc_dffg is
		port(
				 i_CLK        : in std_logic;     -- Clock input
       		     i_RST        : in std_logic;     -- Reset input
       		     i_WE         : in std_logic;     -- Write enable input
       		     i_D          : in std_logic;     -- Data value input
       		     o_Q          : out std_logic);   -- Data value output
	end component;


begin 

generateLower: for i in 0 to 21 generate
	DFFGIL:	dffg 
	port map(
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_WE => i_WE,
		i_D => i_D(i),
		o_Q => o_Q(i));
end generate generateLower;

	DFFGI:	pc_dffg --sets to 1 on reset
	port map(
		i_CLK => i_CLK,
		i_RST => i_RST,
		i_WE => i_WE,
		i_D => i_D(22),
		o_Q => o_Q(22)
		);

		generateUpper: for i in 23 to N-1 generate
		DFFGIU:	dffg 
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => i_WE,
			i_D => i_D(i),
			o_Q => o_Q(i)
		);
	end generate generateUpper;
 

end structural; 
	