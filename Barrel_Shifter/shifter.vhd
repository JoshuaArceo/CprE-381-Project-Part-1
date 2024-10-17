-- 32 bit Barrel Shifter
library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;


entity shifter is 
    generic(N : integer := 32);
    port(
        i_D     : in    std_logic_vector(N-1 downto 0);
        i_AMT     : in    std_logic_vector(4 downto 0);
        i_DIR   : in    std_logic;
        o_Q     : out   std_logic_vector(N-1 downto 0)
    );

end shifter;


-- TODO CONVERT TO STRUCTURAL 32 BIT RIGHT SHIFTER WITH SUPPORT FOR LEFT
architecture dataflow of shifter is

    -- Dir 1 = right
    -- Dir 0 = left
begin
process(i_D, i_AMT, i_DIR)
begin
   
        if i_DIR = '1' then
            o_Q <= std_logic_vector(shift_right(unsigned(i_D), to_integer(unsigned(i_AMT))));
        else
            o_Q <= std_logic_vector(shift_left(unsigned(i_D), to_integer(unsigned(i_AMT))));
        end if;

    
    end process;

end dataflow;