library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder is

  port(i_A1              : in std_logic;
       i_B1              : in std_logic;
       i_C1              : in std_logic;
       o_S1              : out std_logic;
       o_C1              : out std_logic
   );

end fullAdder;

architecture structure of fullAdder is


  component org2 is

  	port(   i_A          : in std_logic;
       		i_B          : in std_logic;
       		o_F          : out std_logic
	);
  end component;

  component andg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component xorg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;


  signal t1	: std_logic;
  signal t2	: std_logic;
  signal t3	: std_logic;
 
  begin

  g_Xor1: xorg2		
    port MAP(i_A               => i_A1,
             i_B               => i_B1,
             o_F               => t1
	    );

  g_And1: andg2		
    port MAP(i_A               => i_A1,
             i_B               => i_B1,
             o_F               => t2
	    );

  g_And2: andg2		
    port MAP(i_A               => t1,
             i_B               => i_C1,
             o_F               => t3
	    );

  g_Xor2: xorg2		
    port MAP(i_A               => t1,
             i_B               => i_C1,
             o_F               => o_S1
	    );

  g_Or1: org2		
    port MAP(i_A               => t2,
             i_B               => t3,
             o_F               => o_C1
	    );
   
end structure;