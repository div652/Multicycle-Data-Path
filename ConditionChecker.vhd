library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use Work.MyTypes.all ; 


entity ConCheck is 
port (
   Z : in std_logic;
      C : in std_logic;
      N : in std_logic;
      V : in std_logic;
  condition_field: in std_logic_vector(3 downto 0);
  predicate : out std_logic
 );
end entity ConCheck;
 
architecture beh of Concheck is 

-- Flags(0) is for z , flags(1) is for C  , flags(2) is for N , flags(3) is for V
begin 
	process(Z,C,N,V,condition_field) is 
    begin
	case condition_field is 
    when "0000" => if(Z='1') then predicate<='1'; else predicate<='0'; end if;
    when "0001" => if(Z='0') then predicate<='1'; else predicate<='0'; end if;
    when "0010" => if(C='1') then predicate<='1'; else predicate<='0'; end if;
    when "0011" => if(C='0') then predicate<='1'; else predicate<='0'; end if;
    when "0100" => if(N='1') then predicate<='1'; else predicate<='0'; end if;
    when "0101" => if(N='0') then predicate<='1'; else predicate<='0'; end if;
    when "0110" => if(V='1') then predicate<='1'; else predicate<='0'; end if;
    when "0111" => if(V='0') then predicate<='1'; else predicate<='0'; end if;
    when "1000" => if(C='1' and Z='0') then predicate<='1'; else predicate<='0'; end if;
    when "1001" =>if(C='0' or Z='1') then predicate<='1'; else predicate<='0'; end if;
    when "1010" =>if(N=V) then predicate<='1'; else predicate<='0'; end if;
    when "1011" =>if(N/=V) then predicate<='1'; else predicate<='0'; end if;
    when "1100" =>if(Z='0' and (N=V)) then predicate<='1'; else predicate<='0'; end if;
    when "1101" =>if((Z='1') or(N/=V) ) then predicate<='1'; else predicate<='0'; end if;
    when others =>predicate<='1';
    
    end case;
    end process;
    end beh;

