library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is

  port(i_S              : in std_logic;
       i_D0             : in std_logic;
       i_D1             : in std_logic;
       o_O               : out std_logic);

end mux2t1;

architecture structure of mux2t1 is


component org2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component andg2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component invg is

  port(i_A          : in std_logic;
       o_F          : out std_logic);
  end component;

  signal t1	: std_logic;
  signal t2	: std_logic;
  signal t3	: std_logic;
 
  begin

  g_And1: andg2		--D1 and S
    port MAP(i_A               => i_D1,
             i_B               => i_S,
             o_F               => t1);

  g_Not1: invg		--S not
    port MAP(i_A               => i_S,
             o_F               => t2);

  g_And2: andg2		--D0 and S not
    port MAP(i_A               => i_D0,
             i_B               => t2,
             o_F               => t3);

  g_Or1: org2		--D0 or D1
    port MAP(i_A               => t1,
             i_B               => t3,
             o_F               => o_O);
   

  
end structure;
