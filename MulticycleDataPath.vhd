
library IEEE;
use IEEE.std_logic_1164.all;
-- use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;
use Work.MyTypes.all ; 

entity MulticycleDataPath is 
	port ( 
	clk : in std_logic;
	reset: in std_logic
	);
	 end entity MulticycleDataPath;
	
architecture Structure of MulticycleDataPath is 

component alu 
	port ( rm : in std_logic_vector(31 downto 0); 
    	   rn : in std_logic_vector(31 downto 0);
       	   opcode : in optype;
           cin: in std_logic;
           cout: out std_logic;
           rd : out std_logic_vector(31 downto 0));
           
          end component;
          
component ProgramCounter  
port( 
  
  ALUaddress : in std_logic_vector(31 downto 0 );  -- this is the address that comes from the ALU , pc goes to this address if PW=1
  outpc : out std_logic_vector(31 downto 0);  --  this is the pc signal that it generates
  clk : in std_logic ; 
  reset:in std_logic ;
	PW : in std_logic  -- if 1 we change outpc else we don;t change it 
  ---  offset : in std_logic_vector(23 downto 0);
---  S_ext : in std_logic_Vector(5 downto 0);-  instype : in instr_class_type ; 
--  predicate : in std_logic ;

);
end component;



component data_mem 
		port(  addr : in std_logic_vector(6 downto 0);
           din : in std_logic_Vector(0 to 31);
           we : in std_logic_vector(3 downto 0);
           clk : in std_logic;
           dout : out std_logic_vector(31 downto 0)
           );
          end component;

component reg_file 
	port(  radd1 : in std_logic_vector(3 downto 0);
    	   radd2 : in std_logic_vector(3 downto 0);
           wadd : in std_logic_vector(3 downto 0);
           din : in std_logic_Vector(31 downto 0);
           rw : in std_logic:='0';
           clk : in std_logic ;
           dout1 : out std_logic_vector(31 downto 0);
           dout2 :out std_logic_vector(31 downto 0));
          end component;
          
component Flagckt  
port ( 
myoperation : in optype;
      clk : in std_logic ; 
      instype : in instr_class_type;
      dptype : in Dp_subclass_type;
      s_bit : in std_logic ;
      shiftrot: in std_logic ; 
      carryalu : in std_logic ; 
      carryshifter : in std_logic;
      Result_alu : in std_logic_Vector(31 downto 0);
      op1msb : in std_logic ; 
      op2msb : in std_logic  ;
		Fset : in std_logic ; -- when I then we modify flags else we don't modify them
      Z : out std_logic:='0';
      C : out std_logic:='0';
      N : out std_logic:='0';
      V : out std_logic:='0'
      
      
      
      
) ;
end component;


--component prog_mem  
--	port(  radd : in std_logic_vector(5 downto 0); 
--           dout : out std_logic_vector(31 downto 0)
--           );
--          end component;
          

component ConCheck  
port (
   Z : in std_logic;
      C : in std_logic;
      N : in std_logic;
      V : in std_logic;
  condition_field: in std_logic_vector(3 downto 0);
  predicate : out std_logic
 );
end component;

component Decoder 
 Port (
instruction : in word;
instr_class : out instr_class_type;
operation : out optype;
DP_subclass : out DP_subclass_type;
DP_operand_src : out DP_operand_src_type;
load_store : out load_store_type;
DT_offset_sign : out DT_offset_sign_type;
dt_signal : out DT_subtype;
mul_command: out mul_command_type;
post_indexing : out std_logic;
writeback : out std_logic
);
end component;
	
component ControlFSM 
	port(

clock : in std_logic ; 
reset : in std_logic;
-- Mem_address : in word; -- output from memory , used to write into IR.
rd1 : in word ; 
rd2: in word;
rdnew2 : in word ; -- these are the two outputs from the registerfile.
instruction_type : in instr_class_type ; 
AluOutput : in word ; -- output from the alu
-- Carryin : in std_logic; -- these are the input flags , these flags are coming from the flag unit , 
-- Carryout : out std_logic; -- these are the output flags, they are different only in branch condition when we change carry flag to 1 , these are then fed into the alu . 

flagset : out std_logic ; -- used to control when to set flags and when not.

DP_subtype : in DP_subclass_type ; 
DT_offset_sign : in DT_offset_sign_type ; 
immediate : in DP_operand_src_type; -- this is reg when DP and registered offset or DT and immediate offset.
load_store : in load_store_type;
predicate : in std_logic ; 
operation : in optype; -- this is the operation signal coming from decoder of the data part, in DP instruction we transmit the same signal as op however in branch or pc increment we pass soem value to alu

A : out word;
B : out word;
IR : out word;
DR : out word;
ShiftedBase : out word;
basereg : out word; --although we could use A also since it holds that vaue at the end of Snew but then we won;t be able to use the register file in the states Sc and SD which might be problematic later on , hence for the sake of convenience we storing it in Basereg
 

M2R : out std_logic_vector(1 downto 0);
Asrc1 : out std_logic;
Asrc2 : out std_logic_vector(1 downto 0);--not thinking about rot or shift currently
RW,PW,IoRD,Rsrc : out std_logic;
MW: out std_logic_Vector(3 downto 0);
opcode : out optype ; 
carrymux : out std_logic;


shift_by_num :in std_logic ; 
Exsel:out std_logic;
Amtsel:out std_logic_vector(1 downto 0);
inputsel : out std_logic;
rad1sel : out std_logic;
Bsel : out std_logic;


Min : out word; 
Instruction : in DT_subtype; 

Rout : in word; 
adr : in std_logic_Vector(1 downto 0);
Mout : in word;
ResChoose: out std_logic; -- this will choose whetehr we want shifted base or baseregister
post_indexing : in std_logic; -- this will be 0 if we want postindexing 
writeback : in std_logic; 
wadcontrol : out std_logic ;
mul_command : in mul_command_type;
mul_Rm,mul_rs,mul_RdLo , mul_RdHi : out word

); 
	
	end component;
	
	
component shifter is 

	port ( shift_type : in shiftrot_type ; 
			shift_amount : in std_logic_vector(4 downto 0);
			in_signal : in std_logic_vector(31 downto 0);
			out_signal : out std_logic_Vector(31 downto 0);
			carry_in : in std_logic;
			carry_out : out std_logic

			);
	
	end component shifter;


  component multiplier is
        
    port( 
      Rm : in word ; 
      Rs : in word;
      RdLo : in word; 
      RdHi : in word; 
      mul_command: in mul_command_type;
      Result : out std_logic_Vector(63 downto 0)
  );
  end component multiplier ; 


	
--ALL COMPONENTS COMPLETED -x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-

---x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x--x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x
signal adr : std_logic_vector(1 downto 0);
signal const1:word:=x"00000001";
signal ALUoutput : word ; -- comes out from ALU as a result of the computation, is fed to PC and various other places for write back. ND
signal outpc: word :=x"00000000" ;  --received from PC goes to Mem and Alu through multiplexers ND
signal PW : std_logic; -- tells to change PC output or not . ND - will be related to ControlFSM
signal Rsrc , asrc1,Flagsetter,RW :std_logic ; 
signal m2r : std_logic_vector(1 downto 0);
signal Asrc2 :std_logic_vector(1 downto 0);

signal MW : std_logic_vector(3 downto 0) ; -- tells the memory to write or not along with the writing type. 
signal IorD :std_logic ; -- tells the MUX1 to choose pc or res. ND , comes from Control FSM
signal IR : word; --  this is the IR register
signal DR : word; -- this is the DR register both of them depend on the control part and change accordingly at clocks. 

signal rd1,rd2 :word ; -- these are the outputs from the register file.

signal MemAddress : std_logic_Vector(6 downto 0);
--will come from a result of output of MUX1 and against inputs from outpc and result address.

signal writeData : word ;  --  this is basically the register value that is coming out from RF , --ND

signal Mout : word ; -- this is the ouput from the memory

signal instruction_class : instr_class_type ; 
signal operation : optype ; -- this comes out of the decoder , goes to control fsm
signal opcode :optype ; -- this is the final opcode that comes out of control and goes to alu
signal DP_subclass : DP_subclass_type;
signal DP_operand_src: DP_operand_src_type;
signal load_store : load_store_type;
signal Dt_offset_sign  : dt_offset_sign_type;
signal shifttypesignal : shiftrot_type ; 

signal shiftrotsignal :std_logic ; 
signal Dt_signal : dt_subtype;

signal Condition_field : std_logic_Vector(3 downto 0);
signal S_bit :std_logic ; 
signal myrad1 : std_logic_vector(3 downto 0);

 
signal temp_rad2: std_logic_vector(3 downto 0);

signal wad:std_logic_vector(3 downto 0);
signal wd : word;
signal rad2 :std_logic_Vector(3 downto 0);
signal Reschoose : std_logic; 

signal EX : word; -- this is the zero extended output ; 


signal S2 : word; -- this is the sign extended "word" offset (not byte) ;
--signal carryshifter:std_logic;


signal control_out_carry : std_logic;
signal  Z,C,N,V : std_logic; -- comes out from flag unit, go to FSm , then becomes control out flags and fed to alu ; ZCVN order . 
signal cout : std_logic; -- carry out from the alu

signal Aluinput2 : word;

signal A,B,basereg,shiftedBase,Res : word; -- base reg and shoftedBase will come out of control FSM while ,Res will be received after multiplexing from these two , we will have a control signal as well to choose which one of the two we want , 
signal Aluinput1 :word;
signal predicate : std_logic;
signal ALU_carry_in :std_logic;
signal carrymux : std_logic;
signal shiftbynum : std_logic;
signal newrd1 : std_logic_Vector(3 downto 0);
signal rdnew2 : std_logic_Vector(31 downto 0);
signal finalEx : std_logic_vector(31 downto 0); 
signal myshifttype : shiftrot_type;
signal shift_amount : std_logic_vector(4 downto 0);
signal shift_insignal : std_logic_Vector(31 downto 0);
signal inputsel : std_logic ; 
signal Asel :std_logic;
signal bsel : std_logic ; 
signal shiftout  :word;
signal carryshifter :std_logic;
signal exsel :std_logic;
signal amtsel :std_logic_vector(1 downto 0);
signal post_indexing: std_logic ; 
signal writeback : std_logic; 
signal wadcontrol : std_logic;

signal mul_Rm,mul_Rs,mul_RdLo,mul_RdHi : word;

signal mul_Result : std_logic_vector(63 downto 0);
signal mul_command : mul_command_type;




signal Min:word; 


begin 
PC1: entity work.ProgramCounter(beh)
	port map( Aluoutput(29 downto 0)&("00") ,outpc, clk , reset , PW); 

my_Multiplier : entity work.Multiplier(beh)
    port map (mul_Rm,mul_Rs,mul_RdLo,mul_RdHi,mul_command,mul_result);


	
-- Memory is now 7 bit . 
 
 Res <= BaseReg when ResChoose='0' else ShiftedBase; 
--ResChoose has to be initialised currently  

MemAddress<= outpc(8 downto 2) when IorD='0' else Res(8 downto 2); --select the top 7 bits in both the cases.
 adr <= outpc(1 downto 0)  when Iord='0' else Res(1 downto 0);
--Mem Address assigned 
--MUX1 completed.

 
------------------------asdfasdfads-fsa--------------------------asdfasdfasdfasdfasdfkaksjdfsklfjasdjf
Data_Memory :entity work.data_mem(beh) port map( MemAddress , Min , MW , clk , Mout);  --MEmInstruction goes to controlFSM where in it goes to PMconnect 
---0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-00-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-00-


shifttypesignal<=none when shift_amount="00000" else lsl; --currently fixing to null 

shiftrotsignal<='0' when shifttypesignal=none else '1' ; 


Condition_field<=IR(31 downto 28);

S_bit<=IR(20);

myrad1<=IR(19 downto 16);

temp_rad2 <= IR(3 downto 0);


newrd1 <= IR(19 downto 16) when asel='0' else IR(11 downto 8);

rdnew2<= rd2 when Bsel='0' else shiftout ; 




wd <=shiftedBase when M2R="00" else DR when M2R="01" else Mul_result(31 downto 0) when M2r="10" else Mul_Result(63 downto 32) ; 

-- wd<=shiftedBase when M2R='0' else DR ; -- wd always gets shifted base instead of  Res,as we know when we are doing wd then shiftedbase hi hoga , there is no point to write baseregister ,as wd is used in DP instructions 


rad2<=temp_rad2 when Rsrc='0' else wad ; 

--wad<=IR(15 downto 12); -- this will now be multiplexed , would be base register in caes when we are writing back , in state SG or SH
wad<=IR(15 downto 12) when WADcontrol='0' else IR(19 downto 16);

EX<=x"00000"&IR(11 downto 0);

S2<=x"FF"&IR(23 downto 0) when IR(23)='1' else x"00"&IR(23 downto 0);

shiftbynum <=IR(4) ; 
--carryshifter<='0';--setting to zero currently
Decoder1: entity work.Decoder(Behavioral) port map(IR,instruction_class , operation ,DP_subclass,dp_operand_src,load_store,Dt_offset_sign,dt_signal,mul_command, post_indexing,writeback);                            

ControlBody : entity work.ControlFSM(beh) port map(clk , reset, rd1,rd2,rdnew2, instruction_class , Aluoutput,Flagsetter ,DP_subclass,DT_offset_sign,DP_operand_src,load_store,predicate,operation,A,B,IR,DR,shiftedBase,basereg,M2R,Asrc1,Asrc2,RW,PW,IoRD,Rsrc,MW,Opcode,carrymux ,shiftbynum,exsel , amtSEL,inputsel,Asel ,bsel, Min , Dt_signal , B, Adr,mout,reschoose,post_indexing,writeback,wadcontrol , mul_command , mul_rm,mul_rs,mul_rdlo,mul_rdhi); -- lot to add here


conditionCheckUnit : entity work.ConCheck(beh) port map(Z,C,N,V, condition_field,predicate);

myregisterFile : entity work.reg_file(beh) port map(newrd1,rad2,wad, wd , rw,clk,rd1,rd2);



Aluinput1<="00"&outpc(31 downto 2) when Asrc1='0' else A;

finalEX <= EX when exsel='1' else shiftout ;

with Asrc2 select Aluinput2 <=B when "00" , const1 when "01",  finalEX when "10" , S2 when others;

ALU_carry_in<= '1' when carrymux='1' else C ;
 
 process(IR) 
 begin
if(IR(27 downto 25)="001") then myshifttype <=rot2 ; 
elsif(IR(6 downto 5)="11") then  myshifttype <= rot;
elsif (IR(6 downto 5)="00") then  myshifttype <= lsl ; 
elsif (IR(6 downto 5)="01") then  myshifttype <= lsr ; 
else myshifttype<=asr;

-- case IR(6 downto 5) is 
--  when ("11") => myshifttype <= rot;
--  when ("00")=> myshifttype<=lsl;
--  when ("01")=>myshifttype<=lsr;
--  when others => myshifttype<=asr;
--  end case ; 
 end if ;
 end process;
 
-- myshifttype <= rot when ((IR(6 downto 5)="11") and (shiftbynum ='0') and (instruction_class=DP) and (dp_operand_src=reg)) else lsl when (IR(6 downto 5)="00" and (shiftbynum='0') and (instruction_class=DP) and (dp_operand_src=reg)) else lsr when (IR(6 downto 5)="01" and (shiftbynum='0') and (instruction_class=DP) and (dp_operand_src=reg)) else asr when (IR(6 downto 5)="10" and (shiftbynum='0') and (instruction_class=DP) and (dp_operand_src=reg)) else rot2; 



myalu : entity work.Alu(beh) port map( aluinput1 ,aluinput2 , opcode , ALU_carry_in , cout,aluOutput);

flagbox : entity work.Flagckt(beh) port map(operation, clk ,instruction_class,dp_subclass,S_bit,shiftrotsignal,cout,carryshifter,aluOutput,aluinput1(31), aluinput2(31), Flagsetter,Z,C,N,V);



with amtsel select  shift_amount <= IR(11 downto 7) when "00" , A(4 downto 0) when "01" ,  (IR(11 downto 8)&'0') when "10" , "00000" when others;
-- shift_amount <= IR(11 downto 7) when amtSEL="00"  else A(4 downto 0) when amtSEL="01" else (IR(11 downto 8)&'0') when amtSEL="10" else "00000";

shift_insignal <= x"000000"&IR(7 downto 0) when inputsel='0' else B ; 


myshifter : entity work.Shifter(beh) port map(myshifttype , shift_amount ,shift_insignal, shiftout , '0' , carryshifter );



	end Structure;
	