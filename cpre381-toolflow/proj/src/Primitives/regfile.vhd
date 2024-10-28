library IEEE;
use IEEE.std_logic_1164.all;

entity regfile is 
generic(
        ADDR_WIDTH : integer := 5;
        DATA_WIDTH : integer := 32);
    port(
        i_rA    : in    std_logic_vector((ADDR_WIDTH-1) downto 0); -- 5 bit register address source
        i_rB    : in    std_logic_vector((ADDR_WIDTH-1) downto 0); -- 5 bit register address target
        i_rW    : in    std_logic_vector((ADDR_WIDTH-1) downto 0); -- 5 bit register address destination
        i_WE    : in    std_logic;
        i_D     : in    std_logic_vector((DATA_WIDTH-1) downto 0);
        i_CLK   : in    std_logic;
        i_RST   : in    std_logic;
        o_ReadA : out   std_logic_vector((DATA_WIDTH-1) downto 0);
        o_ReadB : out   std_logic_vector((DATA_WIDTH-1) downto 0)
    );
end regfile;

architecture structural of regfile is

    component decoder_5t32
        port(
        i_In	: in std_logic_vector(4 downto 0);
		i_WE	: in std_logic;
		o_Out	: out std_logic_vector(31 downto 0));
    end component;

    component reg_N 
        port(
        i_D	: in std_logic_vector;
	     i_RST	: in std_logic;
	     i_CLK	: in std_logic;
	     i_WE	: in std_logic;
	     o_Q	: out std_logic_vector);   
    end component;

    component mux32t1_32
        port(
        i_Reg0  : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg1  : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg2  : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg3  : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg4  : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg5  : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg6  : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg7  : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg8  : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg9  : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg10 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg11 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg12 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg13 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg14 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg15 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg16 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg17 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg18 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg19 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg20 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg21 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg22 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg23 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg24 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg25 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg26 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg27 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg28 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg29 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg30 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Reg31 : in std_logic_vector((DATA_WIDTH-1) downto 0);
        i_Sel    : in std_logic_vector((ADDR_WIDTH-1) downto 0);
        o_Reg   : out std_logic_vector((DATA_WIDTH-1) downto 0)
        );
    end component;


    signal s_WE :  std_logic_vector(31 downto 0); --32 bit write enable after decoder

    type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal s_R : reg_array := (others => (others => '0'));


    begin


    -- DECODE WRITE ADDRESS
    decoder: decoder_5t32
    port map(
        i_In => i_Rw,
        i_WE => i_WE,
        o_Out => s_WE
    );

        reg_zero: reg_N
            port map(
            i_CLK   =>  i_CLK,
            i_RST   =>  '1',      
            i_WE    =>  '1',            
            i_D     =>  X"00000000",            
            o_Q     =>  s_R(0) 
            );

    G_32_REG: for i in 1 to 31 generate
        reg_inst: reg_N
        port map(
            i_CLK   =>  i_CLK,
            i_RST   =>  i_RST,      
            i_WE    =>  s_WE(i),            
            i_D     =>  i_D,            
            o_Q     =>  s_R(i)         
        );

    end generate;

    -- OUTPUT READ A
    muxA: mux32t1_32    
        port map(
            i_Reg0 => s_R(0),
            i_Reg1 => s_R(1),
            i_Reg2 => s_R(2),
            i_Reg3 => s_R(3),
            i_Reg4 => s_R(4),
            i_Reg5 => s_R(5),
            i_Reg6 => s_R(6),
            i_Reg7 => s_R(7),
            i_Reg8 => s_R(8),
            i_Reg9 => s_R(9),
            i_Reg10 => s_R(10),
            i_Reg11 => s_R(11),
            i_Reg12 => s_R(12),
            i_Reg13 => s_R(13),
            i_Reg14 => s_R(14),
            i_Reg15 => s_R(15),
            i_Reg16 => s_R(16),
            i_Reg17 => s_R(17),
            i_Reg18 => s_R(18),
            i_Reg19 => s_R(19),
            i_Reg20 => s_R(20),
            i_Reg21 => s_R(21),
            i_Reg22 => s_R(22),
            i_Reg23 => s_R(23),
            i_Reg24 => s_R(24),
            i_Reg25 => s_R(25),
            i_Reg26 => s_R(26),
            i_Reg27 => s_R(27),
            i_Reg28 => s_R(28),
            i_Reg29 => s_R(29),
            i_Reg30 => s_R(30),
            i_Reg31 => s_R(31),
            i_Sel   => i_rA,
            o_Reg   => o_ReadA
        );

    -- OUTPUT READ B
    muxB: mux32t1_32 
        port map(
            i_Reg0 => s_R(0),
            i_Reg1 => s_R(1),
            i_Reg2 => s_R(2),
            i_Reg3 => s_R(3),
            i_Reg4 => s_R(4),
            i_Reg5 => s_R(5),
            i_Reg6 => s_R(6),
            i_Reg7 => s_R(7),
            i_Reg8 => s_R(8),
            i_Reg9 => s_R(9),
            i_Reg10 => s_R(10),
            i_Reg11 => s_R(11),
            i_Reg12 => s_R(12),
            i_Reg13 => s_R(13),
            i_Reg14 => s_R(14),
            i_Reg15 => s_R(15),
            i_Reg16 => s_R(16),
            i_Reg17 => s_R(17),
            i_Reg18 => s_R(18),
            i_Reg19 => s_R(19),
            i_Reg20 => s_R(20),
            i_Reg21 => s_R(21),
            i_Reg22 => s_R(22),
            i_Reg23 => s_R(23),
            i_Reg24 => s_R(24),
            i_Reg25 => s_R(25),
            i_Reg26 => s_R(26),
            i_Reg27 => s_R(27),
            i_Reg28 => s_R(28),
            i_Reg29 => s_R(29),
            i_Reg30 => s_R(30),
            i_Reg31 => s_R(31),
            i_Sel   => i_rB,
            o_Reg   => o_ReadB
            );
        

    
end structural;