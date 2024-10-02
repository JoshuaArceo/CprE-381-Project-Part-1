-- ADD SUB WITH ALUSRC
library IEEE;
use IEEE.std_logic_1164.all;

entity add_sub_N_ALUSrc is 
	generic(N : integer := 32);
	port(i_A	    : in std_logic_vector(N-1 downto 0);
	     i_B	    : in std_logic_vector(N-1 downto 0);
	     i_nAdd_Sub	: in std_logic;
         i_ALUSrc   : in std_logic;
         i_Imm      : in std_logic_vector(N-1 downto 0);
	     o_S	    : out std_logic_vector(N-1 downto 0);
	     o_Cout	    : out std_logic);
end add_sub_N_ALUSrc;

architecture structure of add_sub_N_ALUSrc  is
    component add_sub_N
    port(
         i_A	    : in std_logic_vector(31 downto 0);
	     i_B	    : in std_logic_vector(31 downto 0);
	     i_nAdd_Sub	: in std_logic;
	     o_S	    : out std_logic_vector(31 downto 0);
	     o_Cout	    : out std_logic);
    end component;

    component mux2t1_N
    port(
        i_S          : in std_logic;
        i_D0         : in std_logic_vector(31 downto 0);
        i_D1         : in std_logic_vector(31 downto 0);
        o_O          : out std_logic_vector(31 downto 0));
    end component;

    signal s_muxOut : std_logic_vector(31 downto 0);

    begin
    
    ImmSel: mux2t1_N
    port map(
        i_S     => i_ALUSrc,
        i_D0    => i_B,
        i_D1    => i_Imm,
        o_O     => s_muxOut 
    );

    AddSub_32: add_sub_N
    port map(
        i_A         => i_A,
        i_B         => s_muxOut,
        i_nAdd_Sub  => i_nAdd_Sub,
        o_S         => o_S,
        o_Cout      => o_Cout  
    );

    end structure;
