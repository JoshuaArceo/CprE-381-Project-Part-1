library IEEE;
use IEEE.std_logic_1164.all;

entity extend16t32 is
    port(
        i_data   : in std_logic_vector(15 downto 0);
        i_signed : in std_logic;
        o_data   : out std_logic_vector(31 downto 0)
    );
end extend16t32;

architecture dataflow of extend16t32 is
begin
    process(i_signed, i_data)
    begin
        if i_signed = '1' then
            o_data(31 downto 16) <= (others => i_data(15));
        else
            o_data(31 downto 16) <= (others => '0');
        end if;
        o_data(15 downto 0) <= i_data;
    end process;
end dataflow;