library IEEE;
use IEEE.std_logic_1164.all;

entity add_sub_N is 
	generic(N : integer := 32);
	port(i_A	: in std_logic_vector(N-1 downto 0);
	     i_B	: in std_logic_vector(N-1 downto 0);
	     i_nAdd_Sub	: in std_logic;
	     o_S	: out std_logic_vector(N-1 downto 0);
		 o_OF	: out std_logic; -- Overflow 
	     o_Cout	: out std_logic);
end add_sub_N;

architecture structure of add_sub_N is 
	component ripple_adder_N
	port(
	    i_A    : in std_logic_vector;
            i_B    : in std_logic_vector;
            i_Cin  : in std_logic;
            o_S    : out std_logic_vector;
			o_OFCIN: out std_logic;
            o_Cout : out std_logic
        );
	end component;

component mux2t1_N

	port(i_D1	: in std_logic_vector;
	     i_D0	: in std_logic_vector;
	     i_S	: in std_logic;
	     o_O	: out std_logic_vector);

end component;

 component onescomp_N is
	port(i_A	: in std_logic_vector;
	     o_F	: out std_logic_vector);
	
end component;

component xorg2 is
	port(
		i_A          : in std_logic;
		i_B          : in std_logic;
		o_F          : out std_logic
	);
end component;

--DEBUG PROBLEM: Found myself struggling trying to figure out why sizes weren't matching up because I had this as
-- (N downto 0); instead of (N-1 downto 0);

signal s_Cin : std_logic;
signal s_Mux : std_logic_vector(N-1 downto 0);
signal s_iBInv: std_logic_vector(N-1 downto 0);
signal s_oCout: std_logic;
signal s_OFCin :std_logic;



begin 
s_Cin <= i_nAdd_Sub;

-- G_NBit_Add_Subs: for i in 0 to N-1 generate
	NBit_inv: onescomp_N
	port map(i_A => i_B,
		 o_F => s_iBInv);

	NBit_mux: mux2t1_N
	port map(
		i_S => i_nAdd_Sub,
		i_D0 => i_B,
		i_D1 => s_iBInv,
		o_O => s_Mux);

	ripple_add: ripple_adder_N
	port map(i_A	=>i_A,
		i_B	=>s_Mux,
		i_Cin	=> s_Cin,
		o_S	=>o_S,
		o_OFCIN => s_OFCin,
		o_Cout	=>s_oCout);

	o_Cout <= s_oCout;
-- end generate G_NBit_Add_Subs;

ofXOR: xorg2
port map(
	i_A => s_OFCin,
	i_B => s_oCout,
	o_F => o_OF
);


end structure;