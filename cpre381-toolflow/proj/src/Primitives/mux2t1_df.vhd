library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_df is
port(i_D1	: in std_logic;
	     i_D0	: in std_logic;
	     i_S	: in std_logic;
	     o_O	: out std_logic);

end mux2t1_df;


architecture dataflow of mux2t1_df is
begin

o_O <= (i_D1 and i_S) or (i_D0 and not i_S);

end dataflow;
