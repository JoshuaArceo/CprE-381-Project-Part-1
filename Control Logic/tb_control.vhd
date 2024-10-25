library IEEE;
use IEEE.std_logic_1164.all;

entity tb_control is
end tb_control;

architecture behavior of tb_control is

    component control
    port(
        readIn     : in  std_logic_vector(5 downto 0);
        jrCode     : in  std_logic_vector(5 downto 0);
        ALUControl : out std_logic_vector(5 downto 0);
        ALUSrc     : out std_logic;
        MemtoReg   : out std_logic;
        jalSig     : out std_logic;
        jrSig      : out std_logic;
        s_DMemWr   : out std_logic;
        s_RegWr    : out std_logic;
        Jump       : out std_logic;
        Branch     : out std_logic;
        s_Halt     : out std_logic;
        RegDst     : out std_logic;
        signExt    : out std_logic
    );
    end component;

    signal readIn     : std_logic_vector(5 downto 0) := (others => '0');
    signal jrCode     : std_logic_vector(5 downto 0) := (others => '0');
    signal ALUControl : std_logic_vector(5 downto 0);
    signal ALUSrc     : std_logic;
    signal MemtoReg   : std_logic;
    signal jalSig     : std_logic;
    signal jrSig      : std_logic;
    signal s_DMemWr   : std_logic;
    signal s_RegWr    : std_logic;
    signal Jump       : std_logic;
    signal Branch     : std_logic;
    signal s_Halt     : std_logic;
    signal RegDst     : std_logic;
    signal signExt    : std_logic;

begin
    uut: control port map (
        readIn     => readIn,
        jrCode     => jrCode,
        ALUControl => ALUControl,
        ALUSrc     => ALUSrc,
        MemtoReg   => MemtoReg,
        jalSig     => jalSig,
        jrSig      => jrSig,
        s_DMemWr   => s_DMemWr,
        s_RegWr    => s_RegWr,
        Jump       => Jump,
        Branch     => Branch,
        s_Halt     => s_Halt,
        RegDst     => RegDst,
        signExt    => signExt
    );

    stim_proc: process
    begin
        -- R-type 
        readIn <= "000000"; jrCode <= "001000";  -- jr
        wait for 100 ns;
        
        readIn <= "000000"; jrCode <= "000000";  -- Other R-type
        wait for 100 ns;

        -- I-type 
        readIn <= "001000"; -- addi
        wait for 100 ns;

        readIn <= "001100"; -- andi
        wait for 100 ns;

        readIn <= "101011"; -- sw
        wait for 100 ns;

        readIn <= "100011"; -- lw
        wait for 100 ns;


        readIn <= "000010"; -- j
        wait for 100 ns;

        readIn <= "000011"; -- jal
        wait for 100 ns;

        readIn <= "010100"; -- halt
        wait for 100 ns;

        readIn <= "000100"; -- beq
        wait for 100 ns;

        readIn <= "000101"; -- bne
        wait for 100 ns;

        wait;
    end process;

end behavior;
