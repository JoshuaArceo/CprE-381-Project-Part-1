-- 32-bit, 32-to-1 Multiplexer with Individual Inputs
library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1_32 is
    port(
        i_Reg0  : in std_logic_vector(31 downto 0);
        i_Reg1  : in std_logic_vector(31 downto 0);
        i_Reg2  : in std_logic_vector(31 downto 0);
        i_Reg3  : in std_logic_vector(31 downto 0);
        i_Reg4  : in std_logic_vector(31 downto 0);
        i_Reg5  : in std_logic_vector(31 downto 0);
        i_Reg6  : in std_logic_vector(31 downto 0);
        i_Reg7  : in std_logic_vector(31 downto 0);
        i_Reg8  : in std_logic_vector(31 downto 0);
        i_Reg9  : in std_logic_vector(31 downto 0);
        i_Reg10 : in std_logic_vector(31 downto 0);
        i_Reg11 : in std_logic_vector(31 downto 0);
        i_Reg12 : in std_logic_vector(31 downto 0);
        i_Reg13 : in std_logic_vector(31 downto 0);
        i_Reg14 : in std_logic_vector(31 downto 0);
        i_Reg15 : in std_logic_vector(31 downto 0);
        i_Reg16 : in std_logic_vector(31 downto 0);
        i_Reg17 : in std_logic_vector(31 downto 0);
        i_Reg18 : in std_logic_vector(31 downto 0);
        i_Reg19 : in std_logic_vector(31 downto 0);
        i_Reg20 : in std_logic_vector(31 downto 0);
        i_Reg21 : in std_logic_vector(31 downto 0);
        i_Reg22 : in std_logic_vector(31 downto 0);
        i_Reg23 : in std_logic_vector(31 downto 0);
        i_Reg24 : in std_logic_vector(31 downto 0);
        i_Reg25 : in std_logic_vector(31 downto 0);
        i_Reg26 : in std_logic_vector(31 downto 0);
        i_Reg27 : in std_logic_vector(31 downto 0);
        i_Reg28 : in std_logic_vector(31 downto 0);
        i_Reg29 : in std_logic_vector(31 downto 0);
        i_Reg30 : in std_logic_vector(31 downto 0);
        i_Reg31 : in std_logic_vector(31 downto 0);
        
        i_Sel    : in std_logic_vector(4 downto 0);
        o_Reg   : out std_logic_vector(31 downto 0)
    );
end mux32t1_32;

architecture Regflow of mux32t1_32 is
begin
    with i_Sel select
        o_Reg <= i_Reg0  when "00000",
                  i_Reg1  when "00001",
                  i_Reg2  when "00010",
                  i_Reg3  when "00011",
                  i_Reg4  when "00100",
                  i_Reg5  when "00101",
                  i_Reg6  when "00110",
                  i_Reg7  when "00111",
                  i_Reg8  when "01000",
                  i_Reg9  when "01001",
                  i_Reg10 when "01010",
                  i_Reg11 when "01011",
                  i_Reg12 when "01100",
                  i_Reg13 when "01101",
                  i_Reg14 when "01110",
                  i_Reg15 when "01111",
                  i_Reg16 when "10000",
                  i_Reg17 when "10001",
                  i_Reg18 when "10010",
                  i_Reg19 when "10011",
                  i_Reg20 when "10100",
                  i_Reg21 when "10101",
                  i_Reg22 when "10110",
                  i_Reg23 when "10111",
                  i_Reg24 when "11000",
                  i_Reg25 when "11001",
                  i_Reg26 when "11010",
                  i_Reg27 when "11011",
                  i_Reg28 when "11100",
                  i_Reg29 when "11101",
                  i_Reg30 when "11110",
                  i_Reg31 when "11111",
                  (others => '0') when others; -- Default case
end Regflow;
