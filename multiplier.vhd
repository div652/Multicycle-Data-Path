library IEEE;
-- library work;
use IEEE.Std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

use Work.MyTypes.all;

entity multiplier is 
    port( 
        Rm : in word ; 
        Rs : in word;
        RdLo : in word; 
        RdHi : in word; 
        mul_command: in mul_command_type;
        Result : out std_logic_Vector(63 downto 0)
    );
    end entity multiplier ; 

architecture beh of multiplier is 

    signal Rd :  std_logic_vector(63 downto 0);



    begin 
        Rd <= (RdHi & RdLo) ; 
        process(mul_command,Rm,Rs,RdHi,RdLo,Rd)
            begin 
                case mul_command is  
                  when   mul => Result<= std_logic_vector(unsigned(Rm)*unsigned(Rs));
                  when   mla => Result<=std_logic_vector((unsigned(Rm)*unsigned(Rs))+unsigned(RdLo));
                  when   smull => Result <=std_logic_vector(signed(Rm)*signed(Rs));
                   when  umull => Result <=std_logic_vector(unsigned(Rm)*unsigned(Rs));
                   when  smlal => Result<=std_logic_vector((signed(Rm)*signed(Rs))+signed(Rd));
                   when  others => Result <=std_logic_vector((unsigned(Rm)*unsigned(Rs))+unsigned(Rd));
                end case;

                    end process;
    end beh ; 