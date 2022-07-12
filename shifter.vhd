
 library IEEE;
 -- library work;
 use IEEE.Std_logic_1164.all;
 use IEEE.NUMERIC_STD.ALL;
 
 use Work.MyTypes.all;
 
 
 entity shifter is 
 
	 port ( shift_type : in shiftrot_type ; 
			 shift_amount : in std_logic_vector(4 downto 0);
			 in_signal : in std_logic_vector(31 downto 0);
			 out_signal : out std_logic_Vector(31 downto 0);
			 carry_in : in std_logic;
			 carry_out : out std_logic);
	 
	 
			 
			
		   end entity shifter;
			  
	 
	 architecture beh of shifter is 
		 
		 
		 
		 component shift_unit 
			 port ( shift_type : in shiftrot_type ; 
			power  : in std_logic;
			carry_in : in std_logic ; 
			carry_out : out std_logic;
			in_signal : in std_logic_vector(31 downto 0) ; 
			out_signal : out std_logic_Vector(31 downto 0));
			 
			
		   end component ;
			  
	 
		 
	 
		 
 
		 
		 signal line1 :  std_logic_vector(31 downto 0);
		 signal line2 :  std_logic_vector(31 downto 0);
		 signal line3 :  std_logic_vector(31 downto 0);
		 signal line4 :  std_logic_vector(31 downto 0);
		 signal carry1 :  std_logic;
		 signal carry2 :  std_logic;
		 signal carry3 :  std_logic;
		 signal carry4 :  std_logic;
		 
		 begin 
		 
		 shift1 : entity Work.shift_unit(beh1) port map(shift_type,shift_amount(0) ,carry_in,carry1 , in_signal , line1);
		 
		 shift2 : entity Work.shift_unit(beh2) port map(shift_type,shift_amount(1) ,carry1,carry2 , line1 , line2);
		 
		 shift4 : entity Work.shift_unit(beh4) port map(shift_type,shift_amount(2) ,carry2,carry3 , line2 , line3);
		 
		 shift8 : entity Work.shift_unit(beh8) port map(shift_type,shift_amount(3) ,carry3,carry4 , line3 , line4);
		 shift16 : entity Work.shift_unit(beh16) port map(shift_type,shift_amount(4) ,carry4,carry_out , line4 , out_signal);
		 
		 
	 
		 
		 end beh; 
		 
		 
		 