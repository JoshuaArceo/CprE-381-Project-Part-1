library IEEE;
use IEEE.std_logic_1164.all;


entity tb_shifter is
    -- generic(gCLK_HPER   : time := 10 ns);
end tb_shifter;



architecture behavior of tb_shifter is
    -- constant cCLK_PER : time := gCLK_HPER *2;

    component shifter is 
    port(
        i_D     : in    std_logic_vector(31 downto 0);
        i_AMT     : in    std_logic_vector(4 downto 0);
        i_DIR   : in    std_logic;
        -- i_CLK   : in    std_logic;
        o_Q     : out   std_logic_vector(31 downto 0)
    );
    end component;

    signal s_D : std_logic_vector(31 downto 0);
    signal s_Q : std_logic_vector(31 downto 0);
    signal s_AMT : std_logic_vector(4 downto 0);
    -- signal s_CLk   : std_logic;
    signal s_DIR : std_logic;



begin 

DUT0: shifter
port map(
     i_D => s_D,
     i_AMT => s_AMT,
     i_DIR => s_DIR,
    -- i_CLK => s_CLK,
     o_Q => s_Q);


-- P_CLK: process
-- begin
-- s_CLK <= '0';
-- wait for gCLK_HPER;
-- s_CLK <= '1';
-- wait for gCLK_HPER;
-- end process;

P_TEST_CASES: process
begin 
    s_D <= "00000000000000000000000011111111";
    s_AMT <= "00001";
    s_DIR <= '1';
    -- wait for cCLK_PER; 
    wait for 10ns;

    s_D <= "00000000000000000000000011111111";
    s_AMT <= "00001";
    s_DIR <= '0';
    -- wait for cCLK_PER;
    wait for 10ns;

    s_D <= "10101010101010101010101010101010";
    s_AMT <= "00011";
    s_DIR <= '1';
    -- wait for cCLK_PER;
    wait for 10ns;

    s_D <= "10101010101010101010101010101010";
    s_AMT <= "00011";
    s_DIR <= '0';
    -- wait for cCLK_PER;
    wait for 10ns;

end process;

end behavior;

