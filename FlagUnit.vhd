library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use Work.MyTypes.all ; 

entity Flagckt is 
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
end entity Flagckt;

architecture beh of Flagckt is 
-- signal  myflags : in std_logic_vector(3 downto 0);

begin 
process(clk) is 
begin 
if(rising_edge(clk) and Fset='1') then 


if(instype= DP) then 

case dptype is 
when arith =>	
	if(s_bit='1')   then 
    if(signed(Result_alu)=0) then Z<='1'; else Z<='0'; end if ;
    c<=carryalu ; 
    N<=Result_alu(31);
    case myoperation is 
    	when add => V<= ((op1msb and op2msb and (not(Result_alu(31))) ) or (not(op1msb) and not(op2msb) and ((Result_alu(31))) )) ;  
        when adc => V<= ((op1msb and op2msb and (not(Result_alu(31))) ) or (not(op1msb) and not(op2msb) and ((Result_alu(31))) )) ;
        
        
        when sub => V<= ((op1msb and (not (op2msb)) and (not(Result_alu(31))) ) or ((not(op1msb)) and (op2msb) and ((Result_alu(31))) )) ;
        when sbc => V<= ((op1msb and (not (op2msb)) and (not(Result_alu(31))) ) or ((not(op1msb)) and (op2msb) and ((Result_alu(31))) )) ;
        
        
        when rsb => V<= ((not(op1msb) and op2msb and (not(Result_alu(31))) ) or ((op1msb) and not(op2msb) and ((Result_alu(31))) )) ;
     when others  => V<= ((not(op1msb) and op2msb and (not(Result_alu(31))) ) or ((op1msb) and not(op2msb) and ((Result_alu(31))) )) ;
        
     end case;
    --V ka likhna hai idhar 
    
    end if;
    

when logic=>
	if(s_bit='1' and shiftrot='1')   then 
    if( signed(Result_alu)=0) then Z<='1'; else Z<='0'; end if ;
    C<=carryshifter;
    N<=Result_alu(31);
    
    elsif(s_bit='1' and shiftrot='0')   then
    if( signed(Result_alu)=0) then Z<='1'; else Z<='0'; end if ;
    N<=Result_alu(31);
    
    end if;
    
when comp =>
		if( signed(Result_alu)=0) then Z<='1'; else Z<='0'; end if ;
         c<=carryalu ; 
   		 N<=Result_alu(31);
         
         case myoperation is 
    	when cmn => V<= ((op1msb and op2msb and (not(Result_alu(31))) ) or (not(op1msb) and not(op2msb) and ((Result_alu(31))) )) ;  
       
         when others => V<= ((op1msb and (not (op2msb)) and (not(Result_alu(31))) ) or ((not(op1msb)) and (op2msb) and ((Result_alu(31))) )) ;
        
        
     end case;
      

        
when others=>
    if(s_bit='1' and shiftrot='1')   then
    if( signed(Result_alu)=0) then Z<='1'; else Z<='0'; end if ;
    C<=carryshifter;
    N<=Result_alu(31);
    
    
    elsif(s_bit='1' and shiftrot='0')   then
    if( signed(Result_alu)=0) then Z<='1'; else Z<='0'; end if ;
    N<=Result_alu(31);
    
    elsif(s_bit='0') then
    if ( signed(Result_alu)=0) then Z<='1'; else Z<='0'; end if ;
    N<=Result_alu(31);
    end if;
    end case;
end if;
end if;

end process;
end beh;
