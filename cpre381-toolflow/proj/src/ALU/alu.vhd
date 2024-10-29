library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity alu is 
    generic(N : integer := 32);        
    port (
        i_OP_A      : in    std_logic_vector(N-1 downto 0);
        i_OP_B      : in    std_logic_vector(N-1 downto 0);
        i_ALUCTRL     : in    std_logic_vector(3 downto 0); -- 4 bit to support 13 functions
        o_F         : out   std_logic_vector(N-1 downto 0);
        o_C_OUT     : out   std_logic;
        o_OVERFLOW  : out   std_logic;
        o_ZERO      : out std_logic
        );
end alu;

-- 0000 and *
-- 0001 or *
-- 0010 add/addi *
-- 0011 addu/addiu
-- 0100 lui
-- 0101 xor
-- 0110 sub *
-- 0111 slt/slti *

-- 1000 subu
-- 1001 sll
-- 1010 srl
-- 1011 sra
-- 1100 repl.qb
-- 1101 nor


architecture structural of alu is

    component shifter is 
    port(
        i_D     : in    std_logic_vector(N-1 downto 0);
        i_AMT     : in    std_logic_vector(4 downto 0);
        i_DIR   : in    std_logic; -- 1 left , 0 right
        i_ARITH   : in    std_logic; -- 0 logical, 1 arithmetic
        o_Q     : out   std_logic_vector(N-1 downto 0)
    );
    end component;

    component and_32bit is 
    port(
        i_A          : in std_logic_vector(31 downto 0);
        i_B          : in std_logic_vector(31 downto 0);
        o_F          : out std_logic_vector(31 downto 0)
    );
    end component;

    component or_32bit is
        port(
        i_A          : in std_logic_vector(31 downto 0);
        i_B          : in std_logic_vector(31 downto 0);
        o_F          : out std_logic_vector(31 downto 0)
    );
    end component;

    component add_sub_N is
        port(
            i_A	: in std_logic_vector(N-1 downto 0);
            i_B	: in std_logic_vector(N-1 downto 0);
            i_nAdd_Sub	: in std_logic;
            o_S	: out std_logic_vector(N-1 downto 0);
            o_OF: out std_logic;
            o_Cout	: out std_logic
            );
    end component;

    component xor_32bit is 
        port(
            i_A          : in std_logic_vector(31 downto 0);
            i_B          : in std_logic_vector(31 downto 0);
            o_F          : out std_logic_vector(31 downto 0)
        );
    end component;

    component nor_32bit is 
    port(
        i_A          : in std_logic_vector(31 downto 0);
        i_B          : in std_logic_vector(31 downto 0);
        o_F          : out std_logic_vector(31 downto 0)
    );
end component;


    component invg is
        port(
            i_A : in std_logic;
            o_F : out std_logic
        );
    end component;

    component andg2 is
        port(
            i_A : in std_logic;
            i_B          : in std_logic;
            o_F          : out std_logic
        );
    end component;

    component replicator is
        port(
            i_A     : in std_logic_vector(31 downto 0);
            i_Byte  : in std_logic_vector(1 downto 0);
            o_F     : out std_logic_vector(31 downto 0)
        );
    end component;
    
    signal s_adder, s_shifter, s_and, s_or, s_xor, s_out, s_slt, s_repl, s_nor, s_shift_me : std_logic_vector(31 downto 0);
    signal s_add_sub, s_overflow, s_out_overflow, s_zero, s_shift_dir, s_shift_type, s_notCout : std_logic;
    signal s_shamt  : std_logic_vector(4 downto 0);

    begin 



    with i_ALUCTRL select
    s_shamt <="10000" when "0100" ,
            i_OP_B(10 downto 6) when others;

    with i_ALUCTRL select
        s_add_sub <= '1' when "1000" | "0110" | "0111", --sets sub bit to 1 when sub or subu or slt
                     '0' when others;

    with i_ALUCTRL select
        s_shift_dir <=  '1' when "1001" | "0100", --shift left 
                        '0' when others;

    with i_ALUCTRL select
        s_shift_type <= '1' when "1011",
                        '0' when others;
                        
    with i_ALUCTRL select
        s_shift_me <= i_OP_B when "0100",
                      i_OP_A when others;       

    and32: and_32bit 
    port map(
        i_A => i_OP_A,
        i_B => i_OP_B,
        o_F => s_and
    );

    or32: or_32bit 
    port map(
        i_A => i_OP_A,
        i_B => i_OP_B,
        o_F => s_or
    );

    addSub: add_sub_N
    port map(
        i_A => i_OP_A,
        i_B => i_OP_B,
        i_nAdd_Sub => s_add_sub,
        o_S => s_adder,
        o_OF => s_overflow,
        o_Cout => o_C_OUT
    );

    xor32: xor_32bit
    port map(
        i_A => i_OP_A,
        i_B => i_OP_B,
        o_F => s_xor
    );

    notCout: invg
    port map(
        i_A => s_overflow,
        o_F => s_notCout
    );

    sltAnd: andg2
    port map(
        i_A => s_notCout,
        i_B => s_adder(31),
        o_F => s_slt(0)
    );

    shift: shifter
    port map(
        i_D => s_shift_me,
        i_AMT => s_shamt,
        i_DIR => s_shift_dir,
        i_ARITH => s_shift_type,
        o_Q => s_shifter
    );

    repl: replicator
    port map(
        i_A => i_OP_A,
        i_Byte => i_OP_B(1 downto 0),
        o_F => s_repl
    );

    nor32: nor_32bit
    port map(
        i_A => i_OP_A,
        i_B => i_OP_B,
        o_F => s_nor
    );

    s_slt(31 downto 1) <= (others => '0');
    


-- 0010 add/addi *
-- 0011 addu/addiu
-- 0100 
-- 0101 xor
-- 0110 sub *
-- 0111 slt *

-- 1000 subu
-- 1001 sll
-- 1010 srl
-- 1011 sra
-- 1100 repl.qb
-- 1101 nor

    with i_ALUCTRL select
        s_out <= s_and when "0000",--and
                 s_or when "0001", -- or
                 s_adder when "0010" | "0011" | "0110" | "1000", --add/addi, addu/addiu, sub, subu
                 s_xor when "0101", --xor
                 s_slt when "0111", --slt
                 s_shifter when "1001" | "1010" | "1011" | "0100", --sll, srl, sra
                 s_repl when "1100",
                 s_nor when "1101",
                 X"00000000" when others;

    
    with i_ALUCTRL select 
    s_out_overflow <= s_overflow when "0010" | "0110", --addu/addiu, subu
                      '0'  when others;
    

    with s_out select
        s_zero <= '1' when X"00000000",
                  '0' when others;



    o_F <= s_out;
    o_OVERFLOW  <= s_out_overflow;
    o_ZERO  <= s_zero;



end structural;
