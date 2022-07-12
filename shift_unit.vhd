
 library IEEE;
 -- library work;
 use IEEE.Std_logic_1164.all;
 use IEEE.NUMERIC_STD.ALL;
 
 use Work.MyTypes.all;
 
 
 
 
 entity shift_unit is 
 
	 port ( shift_type : in shiftrot_type ; 
			power  : in std_logic;
			carry_in : in std_logic ; 
			carry_out : out std_logic;
			in_signal : in std_logic_vector(31 downto 0) ; 
			out_signal : out std_logic_Vector(31 downto 0));
			 
			
		   end entity shift_unit;
 --------------------------------------------------------------------------------------------------------------------------
 architecture beh1 of shift_unit is 
 
	 
	 
	 begin 
	 
	  
	  process(in_signal , carry_in) begin 
	 if(power='0') then 
		 out_signal <=in_signal ;  carry_out<=carry_in;
	  else 
		  case shift_type is 
		 when asr => out_signal<=std_logic_vector(shift_right(signed(in_signal),1));
							 carry_out<=in_signal(0);
				   
		 when lsr => out_signal <=std_logic_vector(shift_right(unsigned(in_signal),1));
							 carry_out<=in_signal(0);
 
					 
		 when Rot => out_signal(30 downto 0) <= in_signal(31 downto 1) ; out_signal(31)<=in_signal(0);  
							 carry_out<=in_signal(0);
			 
			 when Rot2 => out_signal(30 downto 0) <= in_signal(31 downto 1) ; out_signal(31)<=in_signal(0);  
							 carry_out<=in_signal(0);
							 
		 when lsl => out_signal<=std_logic_vector(shift_left(unsigned(in_signal),1));
							 carry_out<=in_signal(31);
			 
			 when others => out_signal<=in_signal ; carry_out<=carry_in; -- I am asssigning no change in case of others
			 end case;
			 end if ;
	  
 
		  end process ;
	 end beh1;
	  
	  
 ---------------------------------------------------------------------------------------------------------------------------------------------
 
 
 architecture beh2 of shift_unit is 
 
	 
	 
	 begin 
	 process(in_signal , carry_in) begin 
	 if(power='0') then 
		 out_signal <=in_signal ;  carry_out<=carry_in;
	  else 
		  case shift_type is 
		 when asr => out_signal<=std_logic_vector(shift_right(signed(in_signal),2));
							 carry_out<=in_signal(1);
				   
		 when lsr => out_signal <=std_logic_vector(shift_right(unsigned(in_signal),2));
							 carry_out<=in_signal(1);
 
 
 
		 when Rot => out_signal(29 downto 0) <= in_signal(31 downto 2) ; out_signal(31 downto 30)<=in_signal(1 downto 0);  
							 carry_out<=in_signal(1);
			 
			 when Rot2 => out_signal(29 downto 0) <= in_signal(31 downto 2) ; out_signal(31 downto 30)<=in_signal(1 downto 0);  
							 carry_out<=in_signal(1);
							 
							 
		 when lsl => out_signal<=std_logic_vector(shift_left(unsigned(in_signal),2));
							 carry_out<=in_signal(30);
			 
			 when others => out_signal<=in_signal ; carry_out<=carry_in;
			 end case;
			 end if ;
 
 
		  end process ;
	 end beh2;
 
 -----------------------------------------------------------------------------------------------------------------------------------------
 
 
 architecture beh4 of shift_unit is 
 
	 
	 
	 begin 
	 process(in_signal , carry_in) begin 
	 if(power='0') then 
		 out_signal <=in_signal ;  carry_out<=carry_in;
	  else 
		  case shift_type is 
		 when asr => out_signal<=std_logic_vector(shift_right(signed(in_signal),4));
							 carry_out<=in_signal(3);
				   
		 when lsr => out_signal <=std_logic_vector(shift_right(unsigned(in_signal),4));
							 carry_out<=in_signal(3);
 
					 
		 when Rot => out_signal(27 downto 0) <= in_signal(31 downto 4) ; out_signal(31 downto 28)<=in_signal(3 downto 0);  
							 carry_out<=in_signal(3);
			 
			 when Rot2 => out_signal(27 downto 0) <= in_signal(31 downto 4) ; out_signal(31 downto 28)<=in_signal(3 downto 0);  
							 carry_out<=in_signal(3);
							 
		 when lsl => out_signal<=std_logic_vector(shift_left(unsigned(in_signal),4));
							 carry_out<=in_signal(28);
			 
			 when others => out_signal<=in_signal ; carry_out<=carry_in;
			 end case;
			 end if ;
	  
 
		  end process ;
	 end beh4;
 ---------------------------------------------------------------------------------------------------------------------------------
 
 
 architecture beh8 of shift_unit is 
 
	 
	 
	 begin 
	 process(in_signal , carry_in) begin
	 if(power='0') then 
		 out_signal <=in_signal ;  carry_out<=carry_in;
	  else 
		  case shift_type is 
		 when asr => out_signal<=std_logic_vector(shift_right(signed(in_signal),8));
							 carry_out<=in_signal(7);
				   
		 when lsr => out_signal <=std_logic_vector(shift_right(unsigned(in_signal),8));
							 carry_out<=in_signal(7);
 
					 
		 when Rot => out_signal(23 downto 0) <= in_signal(31 downto 8) ; out_signal(31 downto 24)<=in_signal(7 downto 0);  
							 carry_out<=in_signal(7);
							 
			 when Rot2 => out_signal(23 downto 0) <= in_signal(31 downto 8) ; out_signal(31 downto 24)<=in_signal(7 downto 0);  
							 carry_out<=in_signal(7);
			 
		 when lsl => out_signal<=std_logic_vector(shift_left(unsigned(in_signal),8));
							 carry_out<=in_signal(24);
			 
			 when others => out_signal<=in_signal ; carry_out<=carry_in;
			 end case;
			 end if ;
	  
 
		  end process ;
	 end beh8;
 ---------------------------------------------------------------------------------------------------------------------------------------
 
 
 architecture beh16 of shift_unit is 
 
	 
	 
	 begin 
	  
	  process(in_signal,carry_in) begin 
	 
	 if(power='0') then 
		 out_signal <= in_signal ;  carry_out<=carry_in;
	  else 
		  case shift_type is 
		 when asr => out_signal<=std_logic_vector(shift_right(signed(in_signal),16));
							 carry_out<=in_signal(15);
				   
		 when lsr => out_signal <=std_logic_vector(shift_right(unsigned(in_signal),16));
							 carry_out<=in_signal(15);
 
					 
		 when Rot => out_signal(15 downto 0) <= in_signal(31 downto 16) ; out_signal(31 downto 16)<=in_signal(15 downto 0);  
							 carry_out<=in_signal(15);
							 
			 when Rot2 => out_signal(15 downto 0) <= in_signal(31 downto 16) ; out_signal(31 downto 16)<=in_signal(15 downto 0);  
							 carry_out<=in_signal(15);
							 
		 when lsl => out_signal<=std_logic_vector(shift_left(unsigned(in_signal),16));
							 carry_out<=in_signal(16);
			 
			 when others => out_signal<=in_signal ; carry_out<=carry_in;
			 end case;
			 end if ;
	  
 
		  end process ;
	 end beh16;
 -----------------------------------------------------------------------------------------------------------------------------------------
 