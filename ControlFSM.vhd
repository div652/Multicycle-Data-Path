library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use Work.MyTypes.all ;


entity ControlFSM is 

port(

clock : in std_logic ; 
reset : in std_logic;
--Mem_address : in word; -- output from memory , used to write into IR.replaced by mout
rd1 : in word ; -- rd1 is output from register file 
rd2: in word;
rdnew2 : in word ; -- rd2 is output from MUX from register file and shifter
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
shiftedbase : out word;
BaseReg : out word; 

M2R : out std_logic_vector(1 downto 0); --chooses memory input from result or from DR
Asrc1 : out std_logic;
Asrc2 : out std_logic_vector(1 downto 0);--not thinking about rot or shift currently
RW,PW,IoRD,Rsrc : out std_logic; -- RW is to select when to enable register wrtie, Pw when to enable pc write, IoRD to choose memory input from PC or from the other part , Rsrc to select rad2 that is the second input fo the register file 
MW: out std_logic_Vector(3 downto 0); -- to select memory mode
opcode : out optype ; -- to select alu operation
carrymux : out std_logic; -- is set to 1 when we necessarily want alu carry to be 1 in the branch case



shift_by_num :in std_logic ;  
Exsel:out std_logic; -- to tell which extension you want to choose
Amtsel:out std_logic_vector(1 downto 0); -- to select which of the four inputs we must choose for the shift amount
inputsel : out std_logic; -- to select input for the shifter
rad1sel : out std_logic; -- helps to multiplex first input of register file
Bsel : out std_logic; -- reading for B from the Shifter, not affecting mul cycles

Min : out word; -- this tells what we have to write in memory comes out from PM Unit, again this won't be affecting multiply as MW=0000 in that case
Instruction : in DT_subtype; 

Rout : in word; 
adr : in std_logic_Vector(1 downto 0);
Mout : in word;
Reschoose : out std_logic; -- to choose whether the result to be used is the shifted output or the base register , won't affect multiply 
post_indexing : in std_logic; 
writeback :in std_logic; 
wadcontrol : out std_logic ;-- in states SG and SH we set this to 1 to write into base register rf(19-16) instead of rf(15-12)

mul_command : in mul_command_type;
mul_Rm,mul_rs,mul_RdLo , mul_RdHi : out word

); 
-- MW ka assignment change karna hai abhi 

end entity ControlFSM;

architecture beh of ControlFSM is 
signal state :state_object ; -- initialised to SA , check if it generates a transaction
signal Rin : word; 

component PMconnect is 
	port ( Rout : in std_logic_vector(31 downto 0); -- this is the value to be stored in mem in store instruction, some
    	   Instruction : in dt_subtype; -- this is the instruction coming from IR , base on this we have to decide what is MW
			ControlState : in state_object; 
			Adr : in std_logic_Vector(1 downto 0); -- this is what will tell us the type of transfer
			Mout : in std_logic_Vector(31 downto 0); -- this will be output from memory , according ADR[1-0] and instruction we will change it so as to suitably store the result in load condition 
			
			Min : out word ; -- this is the value to be written in memory with MW as the other input 
			MW : out std_logic_vector(3 downto 0); 
			Rin : out word  -- this value tells what value has to be written in register in the cawse of load instruciton 
			
         
			);
			end component PMconnect;
			

begin 

PMunit : entity work.PMconnect(beh) port map(Rout,Instruction, state, adr,Mout,Min, MW, Rin); -- lot to add here

	process(clock,reset) 
		begin
		if(reset='1') then state<=SA;
		elsif(rising_edge(clock)) then 
			case state is 
				when SA=> state<=SB;
				when SB => if(predicate='1') then  
									if(instruction_type=DP) then state<=Snew;
									elsif(instruction_type=DT or instruction_type=mul) then state<=Snew;
									else state <=SE ; end if; -- currently ignoring branch and none 
							  else state<=SA; end if;-- when predicate is false we go back to SA whatever be the case , this handles all cases for like addeq, bge etc.
				when Snew => if(instruction_type=DP) then state<=SC; else state<=SD ; end if; 
				
				when SC=> if(dp_subtype=arith or dp_subtype=logic) then state<=SF; -- return to SA if test or compare, ignoring none for this time
								else state<=SA; end if;
				when SD=> if(load_store=store and mul_command=none) then state<=sg; else state<=sh; end if ;
			
				when SH => state<=SI ; 
				
				when others => state<=SA ; -- for SE,SF,SG we always go back to SA, hence clubbed in others.
				
			end case; end if; end process;
			
			
			process(clock)   -- this will be triggered when state changes, this happens only after delta delay of clock, so IR etc. also updated 2-delta delay after clock , 
			-- ie.the value fo these registers is available a delta delay after the clock strikes
            
			begin
                if(rising_edge(clock))
					then 
					
		
					
					if(state=SA) then IR<=Rin ; end if; --IR assignment
					if(state=SH and mul_command=none) then DR<=Rin; end if; --DR assignment , only done in state H if it is not a mul_command, although this is not necessary as when we want DR in load then it is always return in the instruction(we never use DR of a previous instruction)
					if(state=SC or State=SD) then shiftedbase<=AluOutput ; end if ; --ASsignment to Res
					
					if(state =SB ) then A<=rd1 ;mul_rs<=rd1 ;mul_rm<=rdnew2 ;end if;
					if(state =Snew) then A<=rd1; baseReg<=rd1;mul_rdhi<=rd1 ; end if; 
					if(state=SD) then mul_rdlo<=rdnew2 ;end if;
					if(state=SB or state=SD or state=Snew) then B<=rdnew2 ; end if ;
					
					--done with the registers, these were sequential and synchronous. 
					
					-- now all t he multiplexers, these will be concurrent and synchronous, although we don't need them to be concurrent, but making them concurrent would simplify the design, I am gonna make concurrent assignments for that , although it could be done in the same process . but jsut to separate the concurrent and sequential par.
                    
                    end if; 
					
					end process;
                    
                    
			
            m2er: process(mul_command,state) 
            
            	begin 
                	if(state=SH) 
                    	then if(mul_command=mla or mul_command=mul) then M2r<="10" ; elsif (mul_command=none) then m2r<= "00";  else m2r<= "11" ; end if ; 
                     elsif(state=SI) then 
                     		if(mul_command =mla or mul_command=mul) then M2r<="00" ;-- actually at this point write is off, so this is a garbage value
                            elsif(mul_command=none) then M2r<="01"; else m2r<="10"; end if ;
                           
                     else m2r<="00"; end if;
                   end process;
                        
--             	begin 
--                 	case state of 
--                     	when SH => if (mul_command = mla or mul_command=mul ) then M2
-- 			M2r<= "11" when (state=SH and mul_command /= none) else "10" when(state=SI and mul_command/=none) else "01" when (state=SI) else "00"; --  this is the new version of M@R accounting for multiply as well . 

			-- M2R <= '1' when state=SI else '0' ; -- I am assigning zero for all the don't care cases as well
			Asrc1<= '0' when (state=SA or state=SE) else '1' ; -- note that ALU's computation is used only in states A,C,D,E
			Asrc2<= "00" when ((state=SC and immediate=reg) or (state=SD and immediate=imm) or(state=SD and instruction=strh)or(state=sd and instruction=ldrh)or(state=sd and instruction=ldrsh)or(state=sd and instruction=ldrsb)) else "01" when (state=SA) else "10" when ((state=SC and immediate=imm) or (state=SD and immediate=reg)) else "11"; -- Asrc2 is 00 when DP and regisre or dT and register (note that Dt and register is dentoed by imm) , is 01 when Branch in startign , 10 when DP or DT with immediate , is 11 when branch and in dont care condtions
--			MW<="1111" when state=SG else "0000"; -- we write only when state is SG , currenntly we are writing the whole word
			PW<='1' when (state=SA or state=SE) else '0' ; --We write in pc only in state SA or SE
-- 			RW<='1' when (state=SF or state=SI or (state=SG and writeback='1') or (state=SH and writeback='1')or (state=SH and mul_command /= none)) else '0' ;
            RW<='1' when (state=SF or (state=SI and (mul_command/=mla and mul_command/=mul)) or (state=SG and writeback='1') or (state=SH and writeback='1') or (state=SH and mul_command /= none)) else '0' ; 
            -- We write in register file only in states F and I, or when there is writeback in case of SH , -- Ideally I should have included mul check also in write back,but that was a bit hasslesome
			IoRD<='1' when (state=SG or state=SH) else '0' ; -- We access memory in states A,G,H , we choose res in G and H else 0 for A and dont care ones
			Rsrc<='1' when state=SD else '0'; -- only in case of store instruciton do we need to to use Rsrc=1
			carrymux<='1' when state=SE else '0';
            
            
			opcode<=add when (state=SA or (state=SD and Dt_offset_sign=plus)) else operation when state=SC else adc when state=SE else sub ; -- add when PC increment or DT with add offset , operation when DP  , adc when branch instructon , sub when state=SD and DT_offset_sign='0' and in don;t care conditions also sub.
			
			flagset<='1' when (State=SC) else '0';
			
			ExSEL <='0' when (instruction_type=DP and immediate=imm) else '1' ;
			amtSEL <= "00" when (shift_by_num='0' and ((instruction_type=DP and immediate=reg)or (instruction_type=DT and immediate=imm))) 
			 else "01" when  (shift_by_num='1' and ((instruction_type=DP and immediate=reg)or (instruction_type=DT and immediate=imm)))
             else "11" when (shift_by_num='1' and (Instruction=ldrh or Instruction=strh or instruction=ldrsb or instruction=ldrsh))
			 else "10" ;  -- this is 2 in idle conditions and when rot2 else 
			 
			 
			inputSel <='0' when (instruction_type=DP and immediate=imm ) else '1' ; -- this will work for ldrsh etc. also as they are not DP so it will be 1 and with 1 we select register
			
			
			rad1sel <='1' when state=SB else '0';
			Bsel <= '1' when state=Snew else  '0';-- reads from shifter when state is Snew else reads from 
			
			
			
			Reschoose <='0' when ((state=SG or State=SH) and post_indexing='0') else '1' ; 
			wadcontrol<='1' when (state=SG or State=SH) else '0' ; -- only in stae SG or SH will we take BaseReg as write address. 
			
			
			
			
			
			
			 
		--exsel,amtsel,	rdnew karo udhar , mux banao for B and rd1 , naya ex muxed banao , shifter banao 
		
		
-- 			process(clock) is 
-- 			begin 
--             if(rising_edge(clock) ) then 
-- 			flagsout(0)<=flagsin(0) ; flagsout(2)<=flagsin(2);flagsout(3)<=flagsin(3);
			
-- 			case state is 
-- 			when SE => flagsout(1)<='1';
-- 			when others=> flagsout(1)<=flagsin(1);
-- 			end case;
-- --			flagsout(1)<='1' when (state=SE) else flagsin(1); -- that is when we have branch operation we set carry flag to 1 else let it remain as it is.	
-- 			end if;
-- 		--these two statements are triggered whenever a state changes  and according to the state we set the flags. 
-- 			end process;
			
					end beh;
					
			
					
				
