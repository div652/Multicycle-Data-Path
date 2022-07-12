
 library IEEE;
 -- library work;
 use IEEE.Std_logic_1164.all;
 use IEEE.NUMERIC_STD.ALL;
 
 use Work.MyTypes.all;
 
 
 entity alu is 
   port ( rn : in std_logic_vector(31 downto 0); 
          rm : in std_logic_vector(31 downto 0);
             opcode : in optype;
            cin: in std_logic;
            cout: out std_logic;
            rd : out std_logic_vector(31 downto 0));
            
           end entity alu;
 
 architecture beh of alu is 
 
   signal internal : unsigned(32 downto 0) ;
     
     begin 
     cout<=std_logic(internal(32));
 
     rd<=std_logic_vector(internal(31 downto 0));
     
      process(rn,rm,opcode,cin)
        begin 
         
         case opcode is 
         when 
         andop => internal<=(unsigned(rn(31)&rn) and unsigned(rm(31)&rm));
         when
           eor => internal<=(unsigned(rn(31)&rn)xor unsigned(rm(31)&rm));
             
         when 
         sub => internal<=(unsigned(rn(31)&rn)- unsigned(rm(31)&rm));
         when
           rsb => internal<=(unsigned(rm(31)&rm)-unsigned(rn(31)&rn));
         when 
         add => internal<=(unsigned(rn(31)&rn)+unsigned(rm(31)&rm));
         when
           adc => internal<=(unsigned(rn(31)&rn)+unsigned(rm(31)&rm)+(""&cin));
     when 
         sbc => internal<=(unsigned(rn(31)&rn)-unsigned(rm(31)&rm)+(""&cin)-1);
         when
           rsc => internal<=(unsigned(rm(31)&rm)-unsigned(rn(31)&rn)+(""&cin)-1);
         
         when 
         tst => internal<=(unsigned(rn(31)&rn)and unsigned(rm(31)&rm));
         when
           teq => internal<=(unsigned(rn(31)&rn)xor unsigned(rm(31)&rm));
             
         when 
         cmp => internal<=(unsigned(rn(31)&rn) - unsigned(rm(31)&rm));
         when
           cmn => internal<=(unsigned(rn(31)&rn)+ unsigned(rm(31)&rm));
         when 
         orr => internal<=(unsigned(rn(31)&rn)or unsigned(rm(31)&rm));
         when
           mov => internal<=(unsigned(rm(31)&rm));
     when 
         bic => internal<=(unsigned(rn(31)&rn)and not(unsigned(rm(31)&rm)));
         when
           others => internal<=(not(unsigned(rm(31)&rm)));
     end case;
 
          end process ;
     end beh;