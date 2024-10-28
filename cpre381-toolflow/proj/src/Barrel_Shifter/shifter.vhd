-- 32 bit Barrel Shifter
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity shifter is 
    generic(N : integer := 32);
    port(
        i_D         : in    std_logic_vector(N-1 downto 0);
        i_AMT       : in    std_logic_vector(4 downto 0);
        i_DIR       : in    std_logic; -- 1 left , 0 right
        i_ARITH     : in    std_logic;  -- 0 logical, 1 arithmetic
        o_Q         : out   std_logic_vector(N-1 downto 0)
    );

end shifter;

architecture structural of shifter is

    component mux2t1_N is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
      port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
    end component;

    component mux2t1_df is 
    port(
        i_D1	: in std_logic;
        i_D0	: in std_logic;
        i_S	: in std_logic;
        o_O	: out std_logic
    );
    end component;

    signal s_shifted_bit : std_logic;
    signal s_data, s_inLeft, s_oLeft : std_logic_vector(31 downto 0);

    signal s_in_amt0, s_in_amt1, s_in_amt2, s_in_amt3, s_in_amt4, 
    s_out_amt0, s_out_amt1, s_out_amt2, s_out_amt3, s_out_amt4  : std_logic_vector(31 downto 0);

    begin
    --if left shift reverse order
    reverse: for i in 0 to 31 generate
    s_inLeft(i) <= i_D(31 - i);
    end generate;
    

    dir_mux: mux2t1_N
    port map(
        i_S => i_DIR,
        i_D0 => i_D,
        i_D1 => s_inLeft,
        o_O => s_data
    );
    

    logical_mux: mux2t1_df
    port map(
        i_D0 => '0',
        i_D1 => s_data(31),
        i_S => i_ARITH,
        o_O => s_shifted_bit
    );


    s_in_amt0(30 downto 0) <= s_data(31 downto 1);
    s_in_amt0(31) <= s_shifted_bit;

    --if shift bit 0 is 1, shift 1 bit
    shift0_mux: mux2t1_N
    port map(
        i_S => i_AMT(0),
        i_D0 => s_data,
        i_D1 => s_in_amt0,
        o_O => s_out_amt0
    );


    s_in_amt1(29 downto 0) <= s_out_amt0(31 downto 2);

    fill1: for i in 30 to 31 generate 
        s_in_amt1(i) <= s_shifted_bit;
    end generate;

    shift1_mux: mux2t1_N
    port map(
        i_S => i_AMT(1),
        i_D0 => s_out_amt0,
        i_D1 => s_in_amt1,
        o_O => s_out_amt1
    );

    s_in_amt2(27 downto 0) <= s_out_amt1(31 downto 4);

    fill2: for i in 28 to 31 generate 
        s_in_amt2(i) <= s_shifted_bit;
    end generate;

    shift2_mux: mux2t1_N
    port map(
        i_S => i_AMT(2),
        i_D0 => s_out_amt1,
        i_D1 => s_in_amt2,
        o_O => s_out_amt2
    );


    s_in_amt3(23 downto 0) <= s_out_amt2(31 downto 8);

    fill3: for i in 24 to 31 generate 
        s_in_amt3(i) <= s_shifted_bit;
    end generate;

    shift3_mux: mux2t1_N
    port map(
        i_S => i_AMT(3),
        i_D0 => s_out_amt2,
        i_D1 => s_in_amt3,
        o_O => s_out_amt3
    );

    s_in_amt4(15 downto 0) <= s_out_amt3(31 downto 16);

    fill4: for i in 16 to 31 generate 
        s_in_amt4(i) <= s_shifted_bit;
    end generate;

    shift4_mux: mux2t1_N
    port map(
        i_S => i_AMT(4),
        i_D0 => s_out_amt3,
        i_D1 => s_in_amt4,
        o_O => s_out_amt4
    );

    --reverse for left out
    reverseOut: for i in 0 to 31 generate
    s_oLeft(i) <= s_out_amt4(31 - i);
    end generate;

    output_mux: mux2t1_N
    port map (
        i_S => i_DIR,
        i_D0 => s_out_amt4,
        i_D1 => s_oLeft,
        o_O => o_Q
    );

    end structural;
