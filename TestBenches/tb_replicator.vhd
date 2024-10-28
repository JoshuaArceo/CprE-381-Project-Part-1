library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity tb_replicator is
    end tb_replicator;

architecture mixed of tb_replicator is
    component replicator is

    port(
        i_A     : in std_logic_vector(31 downto 0);
        i_Byte  : in std_logic_vector(1 downto 0);
        o_F     : out std_logic_vector(31 downto 0)
    );
    end component;

    signal s_in, s_out : std_logic_vector(31 downto 0);
    signal s_byte : std_logic_vector(1 downto 0);


    begin 

    DUT0: replicator
    port map(
        i_A => s_in,
        i_Byte => s_byte,
        o_F => s_out
    );

    P_TEST_CASES: process
    begin
    s_in <= X"ABCD1234";
    s_byte <= "00";
    wait for 10ns;

    s_byte <= "01";
    wait for 10ns;

    s_byte <= "10";
    wait for 10ns;

    s_byte <= "11";
    wait for 10ns;

    end process;
    end mixed;


