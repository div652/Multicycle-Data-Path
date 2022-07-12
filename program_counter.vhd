

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use Work.MyTypes.all ; 

entity ProgramCounter is 
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
end entity ProgramCounter;

architecture beh of ProgramCounter is 
	begin
process(clk,reset) is 
begin 
	if(reset='1') then outpc<=x"00000000";
    

    -- currently doesnot work for cases like addeq when if predicate is false we do not execute anything , if I counter addeq in this model and if predicate is false then also instruction is executed , this comment was made in the single cycle data path , may not be relevant here. 
  elsif(rising_edge(clk) and PW='1')  then 
			outpc<=aluaddress ; 
end if ; 
end process;

end beh ; 
