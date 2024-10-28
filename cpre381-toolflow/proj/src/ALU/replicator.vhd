library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity replicator is
    generic(N : integer := 32);    
    port (
        i_A     : in std_logic_vector(N-1 downto 0);
        i_Byte  : in std_logic_vector(1 downto 0);
        o_F     : out std_logic_vector(N-1 downto 0)
    );
end replicator;

architecture dataflow of replicator is
    signal s_repl : std_logic_vector(7 downto 0); --one byte

    begin
        with i_Byte select
            s_repl <= i_A(7 downto 0) when "00",
                      i_A(15 downto 8) when "01",
                      i_A(23 downto 16) when "10",
                      i_A(31 downto 24) when others;

        o_F <= s_repl & s_repl & s_repl & s_repl;

end dataflow;
