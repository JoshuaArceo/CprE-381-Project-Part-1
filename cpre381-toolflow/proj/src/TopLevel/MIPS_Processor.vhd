-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated


  -- Instruction Signals
  signal s_inst_total   : std_logic_vector((DATA_WIDTH-1) downto 0);
  signal s_inst_opcode, s_instFunc    :std_logic_vector(5 downto 0);
  signal s_inst_addrRS, s_inst_Addr_RT, s_inst_Addr_RD, s_inst_shamt: std_logic((ADDR_WIDTH -1) downto 0);
  signal s_instImm      : std_logic_vector((16-1) downto 0);




  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

    component fetch_logic is
      generic(DATA_WIDTH : integer)
      PORT (
        i_PC              : in std_logic_vector((DATA_WIDTH - 1) DOWNTO 0); 
        i_branch_to_adder : in std_logic_vector((DATA_WIDTH - 1) DOWNTO 0); 
        i_jump_to_adder   : in std_logic_vector((DATA_WIDTH - 1) DOWNTO 0); 
        i_jr              : in std_logic_vector((DATA_WIDTH - 1) DOWNTO 0); 
        i_jr_to_select    : in std_logic;                        
        i_branch          : in std_logic;                        
        i_zero            : in std_logic;                        
        i_jump            : in std_logic;                        
        o_PC              : out std_logic_vector((DATA_WIDTH - 1) DOWNTO 0); 
        o_PC_plus_4       : out std_logic_vector((DATA_WIDTH - 1) downto 0) 
        );
      end component;
      
      component regfile is 
      generic(
        ADDR_WIDTH : integer;
        DATA_WIDTH : integer);
      port(
        i_rA    : in    std_logic_vector((ADDR_WIDTH-1) downto 0); -- 5 bit register address source
        i_rB    : in    std_logic_vector((ADDR_WIDTH-1) downto 0); -- 5 bit register address target
        i_rW    : in    std_logic_vector((ADDR_WIDTH-1) downto 0); -- 5 bit register address destination
        i_WE    : in    std_logic;
        i_D     : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
        i_CLK   : in    std_logic;
        i_RST   : in    std_logic;
        o_ReadA : out   std_logic_vector((DATA_WIDTH - 1) downto 0);
        o_ReadB : out   std_logic_vector((DATA_WIDTH - 1) downto 0)
    );
    end component;

    component mux2t1_N is
      generic(DATA_WIDTH : integer)
      port(i_S          : in std_logic;
       i_D0         : in std_logic_vector((DATA_WIDTH - 1) downto 0);
       i_D1         : in std_logic_vector((DATA_WIDTH - 1) downto 0);
       o_O          : out std_logic_vector((DATA_WIDTH - 1) downto 0));
      end component;

  component shifter is
  port(
        i_D     : in    std_logic_vector(N-1 downto 0);
        i_AMT     : in    std_logic_vector(4 downto 0);
        i_DIR   : in    std_logic; -- 1 left , 0 right
        i_ARITH   : in    std_logic; -- 0 logical, 1 arithmetic
        o_Q     : out   std_logic_vector(N-1 downto 0)
    );
    end component;

    component extend16t32 is
      port(
        i_data   : in std_logic_vector((DATA_WIDTH/2 -1) downto 0);
        i_signed : in std_logic;
        o_data   : out std_logic_vector((DATA_WIDTH - 1) downto 0)
    );
    end component;

    component ALUcontrol is 
    port(s_type       : in std_logic_Vector(5 downto 0);
         opcode       : in std_logic_Vector(5 downto 0);
         s_out        : out std_logic_Vector(3 downto 0)
	   );  
     end component;

     component alu is 
     port (
          i_OP_A      : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
          i_OP_B      : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
          i_ALUOP     : in    std_logic_vector(3 downto 0); -- 4 bit to support 13 functions
          o_F         : out   std_logic_vector((DATA_WIDTH - 1) downto 0);
          o_C_OUT     : out   std_logic;
          o_OVERFLOW  : out   std_logic;
          o_ZERO      : out std_logic
        );
        end component;
     
     component control is 
        port( 
          readIn       :   in std_logic_vector(5 downto 0); --bits 31-26 opcode
          jrCode       :   in std_logic_vector(5 downto 0);
          ALUControl   :   out std_logic_vector(5 downto 0); --0010 will perform add of A and B
          ALUSrc       :   out std_logic; --use correcty extended immediate from B
          MemtoReg     :   out std_logic; -- on 0 does not read from memory
          jalSig       :   out std_logic;
          jrSig        :   out std_logic;
          s_DMemWr     :   out std_logic; --memwrite from text, on 0 does not write to memory
          s_RegWr      :   out std_logic; --Regwrite from text, on 1 writes back to a register
          Jump	       :   out std_logic;
          Branch	     :   out std_logic;
          s_Halt	     :   out std_logic;
          RegDst       :   out std_logic --uses rt as destination register rather than rd
          ); 
      end component;

      component ripple_adder_N is
        port(
          i_A	: in std_logic_vector((DATA_WIDTH - 1) downto 0);
          i_B	: in std_logic_vector((DATA_WIDTH - 1) downto 0);
          i_Cin	: in std_logic;
          o_S	: out std_logic_vector((DATA_WIDTH - 1) downto 0);
          o_OFCIN: out std_logic; --ignore this is only used in ALU
          o_Cout	: out std_logic
        );

      end component;

      begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

end structure;
