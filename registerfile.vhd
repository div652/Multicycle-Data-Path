library IEEE;
use IEEE.std_logic_1164.all;
--  USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- use IEEE.Numeric_std.all;
 USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- use IEEE.std_logic_arith.all;
use Work.mytypes.all;
entity reg_file is 
	port(  radd1 : in std_logic_vector(3 downto 0);
    	   radd2 : in std_logic_vector(3 downto 0);
           wadd : in std_logic_vector(3 downto 0);
           din : in std_logic_Vector(31 downto 0);
           rw : in std_logic:='0';
           clk : in std_logic ;
           dout1 : out std_logic_vector(31 downto 0);
           dout2 :out std_logic_vector(31 downto 0));
          end entity reg_file;
        
architecture beh of reg_file is 
	
    type storage is array (0 to 15) of std_logic_vector(31 downto 0);
    signal useless : bit :='0' ; 
	signal mem : storage:=(0 => x"00000000" , 1=>x"00000000" , 2=>x"00000000" , 3=>x"00000000" , 4=>x"00000000" , others=>x"00000000");
   
    begin 
 
    
    
    process(clk) is 
    begin 
    	if(rising_edge(clk) and rw='1')
            then 
            	mem(conv_integer(wadd))<=din;
        end if;
        end process;
        
    
    dout1<=mem(conv_integer(radd1));
    dout2<=mem(conv_integer(radd2));
    
    end beh;