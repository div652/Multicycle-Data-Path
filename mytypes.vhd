library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.all;
package MyTypes is
subtype word is std_logic_vector (31 downto 0);
subtype hword is std_logic_vector (15 downto 0);
subtype byte is std_logic_vector (7 downto 0);
subtype nibble is std_logic_vector (3 downto 0);
subtype bit_pair is std_logic_vector (1 downto 0);
type optype is (andop, eor, sub, rsb, add, adc, sbc, rsc,
tst, teq, cmp, cmn, orr, mov, bic, mvn);
type instr_class_type is (DP, DT, MUL, BRN, none);
type DP_subclass_type is (arith, logic, comp, test, none);
type DP_operand_src_type is (reg,imm);
type load_store_type is (load, store);
type DT_offset_sign_type is (plus, minus);
type shiftrot_type is (lsl , lsr , asr , Rot, Rot2,none);
type state_object is (SA,SB,Sc,SD,SE,SF,SG,SH,SI, Snew) ; -- SA denotes State A 
type dt_subtype is (ldr,str,ldrb,ldrsb,strb,ldrh,ldrsh,strh,none) ;
type mul_command_type is (mul,mla,smull,umull,umlal,smlal,none);
-- defining this shiftrot signal that tells which shift and if Rot then right rotation , Rot2 then right rotation with twice the amount
end MyTypes;
package body MyTypes is
end MyTypes;
