library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity data_mem is 
	port(  addr : in std_logic_vector(6 downto 0);
           din : in std_logic_Vector(31 downto 0);
           we : in std_logic_vector(3 downto 0);
           clk : in std_logic;
           dout : out std_logic_vector(31 downto 0)
           );
          end entity data_mem;
        
architecture beh of data_mem is 
	
    type storage is array (0 to 127) of std_logic_vector(31 downto 0);
    signal useless : bit :='0' ;
	signal mem : storage:=    (0 => X"e3a0100a", 1=>x"e3a02014" , 2 => X"e3a0301e", 3 => X"e3a04032", 4 => X"e0e21493",5 =>x"e0a21493",6 => x"e0813002" ,7 =>x"00000000", 8 => x"00000000", 9 => x"00000000" , 10 => x"00000000",11 => x"00000000", others => X"00000000" );
    
    
    

    
    begin 
--     process(clk) is 
--     begin 
--     	if(rising_edge(clk))
--             then 
--             	for i in  0 to 3 loop 
--                 	if(we(i)='1') then
--                     	mem(conv_integer(wadd))((8*i) to (8*i+7))<=din((8*i) to (8*i+7)) ; 
--                     else useless <= not(useless) ; 
--                     end if ;
--                         end loop;
--         end if;
--         end process;
        
        
     process(clk) is 
     begin 
     	if(rising_edge(clk) and  we/="0000") then
            	case we is 
                when "1111" =>
                	mem(conv_integer(addr))<=din ; 
--                     
                when "1100"=>
                	mem(conv_integer(addr))(31 downto 16)<=din(15 downto 0) ; 
--                
                   when "0011"=>
                	mem(conv_integer(addr))(15 downto 0)<=din(15 downto 0) ; 
--                     
                    when "1000"=>
                	mem(conv_integer(addr))(31 downto 24)<=din(7 downto 0) ; 
--                 
                    when "0100"=>
                	mem(conv_integer(addr))(23 downto 16)<=din(7 downto 0) ;
--                    
                    when "0010"=>
                	mem(conv_integer(addr))(15 downto 8)<=din(7 downto 0) ;
--                     
                    when  others=>
                	mem(conv_integer(addr))(7 downto 0)<=din(7 downto 0) ;                 
            end case; end if ; 
            
                    end process ; 
                    
              process(we,addr) is
              begin 
              if(we="0000") then dout<=mem(conv_integer(addr)) ; 
--               
              end if ; 
              end process;
				  
    
        
    end beh;