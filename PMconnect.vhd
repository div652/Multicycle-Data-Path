library IEEE;
use IEEE.std_logic_1164.all;
 USE IEEE.STD_LOGIC_UNSIGNED.ALL;
 
use Work.MyTypes.all;


entity PMconnect is 
	port ( Rout : in std_logic_vector(31 downto 0); -- this is the value to be stored in mem in store instruction, some
    	   Instruction : in dt_subtype; -- this is the instruction coming from IR , base on this we have to decide what is MW
			State : in state_object; 
			Adr : in std_logic_Vector(1 downto 0); -- this is what will tell us the type of transfer
			Mout : in std_logic_Vector(31 downto 0); -- this will be output from memory , according ADR[1-0] and instruction we will change it so as to suitably store the result in load condition 
			
			Min : out word ; -- this is the value to be written in memory with MW as the other input 
			MW : out std_logic_vector(3 downto 0); 
			Rin : out word  -- this value tells what value has to be written in register in the cawse of load instruciton 	
         
			);
           
          end entity PMconnect;

architecture beh of PMconnect is 

	
    
    begin 
	 -- aim is to make Min nonzero only in the case of store 
	 -- to make Rin as 000.. in case state=SG , Rin as mem output in all states other than load 
	 -- to make MW=0000 in all cases other than store 
	 
	 process(instruction, Rout, adr, Mout,state) 
	 begin 
	 
	if(state=SG or  state=SH) then 
		if(instruction=str) then MW<="1111" ; Min<=Rout; 
		elsif(instruction=strh and adr="00") then MW<="0011" ; Min<=Rout ; Rin <=x"00000000";
		elsif(instruction=strh and adr="10") then MW<="1100" ; Min<=Rout ;Rin <=x"00000000";
		
		elsif(instruction=strb and adr="00") then MW<="0001" ; Min<=Rout; Rin <=x"00000000";
		
		elsif(instruction=strb and adr="01") then MW<="0010" ; Min<=Rout;Rin <=x"00000000"; 
		elsif(instruction=strb and adr="10") then MW<="0100" ; Min<=Rout;Rin <=x"00000000"; 
		elsif(instruction=strb and adr="11") then MW<="1000" ; Min<=Rout;Rin <=x"00000000";
-------------------------------------------------------------------------------------
------------------------------------------------------------------------------------ 
		
		elsif(instruction=ldr and adr="00") then MW<="0000"; Min<=x"00000000"; Rin<=Mout;
		
		
		
		elsif(instruction=ldrh and adr="00") then MW<="0000"; Min<=x"00000000"; Rin(31 downto 16)<=x"0000" ; Rin(15 downto 0)<=Mout(15 downto 0);
		
		elsif(instruction=ldrh and adr="10") then MW<="0000"; Min<=x"00000000"; Rin(31 downto 16)<=x"0000" ; Rin(15 downto 0)<=Mout(31 downto 16);
		
		
		
		elsif(instruction=ldrsh and adr="00") then MW<="0000"; Min<=x"00000000"; for i in 31 downto 16 loop  Rin(i)<=Mout(15) ; end loop ; Rin(15 downto 0)<=Mout(15 downto 0);
		
		
		elsif(instruction=ldrsh and adr="10") then MW<="0000"; Min<=x"00000000"; for i in 31 downto 16 loop  Rin(i)<=Mout(31) ; end loop ; Rin(15 downto 0)<=Mout(31 downto 16);
		
		
		
		elsif(instruction=ldrb and adr="00") then MW<="0000"; Min<=x"00000000"; Rin(31 downto 8) <=x"000000"; Rin(7 downto 0)<=Mout(7 downto 0);
		
		elsif(instruction=ldrb and adr="01") then MW<="0000"; Min<=x"00000000"; Rin(31 downto 8) <=x"000000"; Rin(7 downto 0)<=Mout(15 downto 8);
		
		elsif(instruction=ldrb and adr="10") then MW<="0000"; Min<=x"00000000"; Rin(31 downto 8) <=x"000000"; Rin(7 downto 0)<=Mout(23 downto 16);
		
		elsif(instruction=ldrb and adr="11") then MW<="0000"; Min<=x"00000000"; Rin(31 downto 8) <=x"000000"; Rin(7 downto 0)<=Mout(31 downto 24);
		
		
		
		elsif(instruction=ldrsb and adr="00") then MW<="0000"; Min<=x"00000000"; for i in 31 downto 8 loop Rin(i)<=Mout(7) ; end loop ; Rin(7 downto 0)<=Mout(7 downto 0);
		
		elsif(instruction=ldrsb and adr="01") then MW<="0000"; Min<=x"00000000"; for i in 31 downto 8 loop Rin(i)<=Mout(15) ; end loop ; Rin(7 downto 0)<=Mout(15 downto 8);
		
		elsif(instruction=ldrsb and adr="10") then MW<="0000"; Min<=x"00000000"; for i in 31 downto 8 loop Rin(i)<=Mout(23) ; end loop ; Rin(7 downto 0)<=Mout(23 downto 16);
		
		elsif(instruction=ldrsb and adr="11") then MW<="0000"; Min<=x"00000000"; for i in 31 downto 8 loop Rin(i)<=Mout(31) ; end loop ; Rin(7 downto 0)<=Mout(31 downto 24);
		
		
		
		
		
		else -- this is the condition when instruction is notload or store 
			
			MW<="0000" ; Min <=x"00000000" ; Rin<=x"00000000"; -- when state is SG but instruciton is not load or store, ie . erraneous conditoin 
		end if ; 

		
	else MW<="0000"; Min<=x"00000000"  ; Rin<=Mout ; 
		-- this is the condition when we are not in the state SG 

end if ; 
	 
         end process ;
    end beh;