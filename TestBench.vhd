library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use Work.MyTypes.all ;
-- import MyTypes::*;
entity test_bench is 
end entity test_bench ;

architecture mytest of test_bench is 
signal tclk : std_logic; 
signal treset : std_logic;

component MulticycleDataPath is 
	port ( 
	clk : in std_logic;
	reset: in std_logic
	);
          end component MulticycleDataPath;
          
begin
DUT : 
MulticycleDataPath port map(tclk,treset);

clkwork:
process 
begin 
tclk<='0';
wait for 4ns;
tclk<='1';
wait for 2ns ;

for i in 1 to 115 loop 
tclk<='0';
wait for 2ns ;
tclk<='1';
wait for 2ns ;
end loop ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;
-- tclk<='1';
-- wait for 2ns ;
-- tclk<='0';
-- wait for 2ns ;





wait;
end process;

process
begin 
treset<='1';
wait for 1 ns;
treset<='0';
wait;
end process;

end mytest;
