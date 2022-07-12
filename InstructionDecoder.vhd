

library IEEE;
use IEEE.std_logic_1164.all;

use ieee.numeric_std.all;

use Work.MyTypes.all ; 

entity Decoder is
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
writeback : out std_logic -- if 1 it means we have to write back 
);
end Decoder;
architecture Behavioral of Decoder is
type oparraytype is array (0 to 15) of optype;
constant oparray : oparraytype :=
(andop, eor, sub, rsb, add, adc, sbc, rsc,
tst, teq, cmp, cmn, orr, mov, bic, mvn);
begin

process(instruction)
begin 
if((instruction(27 downto 25)="000" and Instruction(4)='1' and instruction(7)='1') or instruction(27 downto 26)="01") then 
instr_class<=Dt ;
elsif(instruction(27 downto 24)="0000" and instruction(7 downto 4)="1001") then instr_class<=mul ;

elsif (instruction(27 downto 26)="00") then instr_class<=DP ; 
elsif(instruction(27 downto 26)="10") then instr_class<=BRN;
else instr_class<=none;
end if ; 
end process;

operation <= oparray (to_integer(unsigned (
instruction (24 downto 21)))) ;
with instruction (24 downto 22) select
DP_subclass <= arith when "001" | "010" | "011",
logic when "000" | "110" | "111",
comp when "101",
test when others;
DP_operand_src <= reg when instruction (25) = '0' else imm; -- for DT when we have immediate operand then reg is assigned (ie. the opposite)
load_store <= load when instruction (20) = '1' else store;
DT_offset_sign <= plus when instruction (23) = '1' else
minus;

process(instruction) 
begin 
if(instruction(27 downto 24) ="0000") then 

		if(instruction(23 downto 22)="00") then 
			if(instruction(21)='1') then mul_command<=mla; 
		    else mul_command<=mul ; end if;
		elsif(instruction(23)='1') then 
		    if(instruction(22 downto 21)="00") then mul_command<=umull;
		    elsif(instruction(22 downto 21)="01") then mul_command<=umlal;
		    elsif(instruction(22 downto 21)="10") then mul_command<=smull;
		    else mul_command<=smlal;

		    end if ; 
		else mul_command<=none; end if ; 
else mul_command<=none;  end if;
end process;


process(instruction) 
begin 
if(instruction(27 downto 26)="01") then 
   if(instruction(20)='0' and instruction(22)='0') then dt_signal <=str;
	elsif(instruction(20)='0' and instruction(22)='1') then dt_Signal <=strb;
	elsif(instruction(20)='1' and instruction(22)='0') then dt_Signal <=ldr; 
	else dt_Signal<=ldrb; end if ; 
elsif(instruction(27 downto 25)="000" and Instruction(4)='1' and instruction(7)='1') then 
	if(instruction(6 downto 5)="01" and instruction(20)='1') then dt_Signal <=ldrh;
	elsif(instruction(6 downto 5)="01" and instruction(20)='0') then dt_Signal <=strh;
	elsif(instruction(6 downto 5)="10" and instruction(20)='1') then dt_signal <=ldrsb;
	elsif(instruction(6 downto 5)="11" and instruction(20)='1') then dt_Signal <=ldrsh;
	else dt_signal <=none;  end if ; 
	


else dt_Signal <=none; 
end if ; 
end process; 

post_indexing<='0' when (instruction(24)='0') else '1'; -- 0 indicates postindexing is ON else OFF
writeback<='1' when ((instruction(24)='0') or instruction(21)='1') else '0'; -- ideally should have included mul_command<>none in writeback however that is hasslesome so I am doing that thing in Control Part separately when I send mul_command over there. 


end Behavioral;