LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
 entity FSM1 is
   port (
    max_min_calculation : inout std_logic := '0';
    clk : inout std_logic:='0' ;
    normalisation_done : inout std_logic := '0';
    cur_state : inout integer := 0
   ) ;
 end FSM1 ;
 -- state = 0 means the state when we are only calculating the min and max and not doing anything else
 --1 for the state when we are doing the normalisation process and also writing in the ram after normalisation;
 --2 for the vga part;

 architecture arch of FSM1 is


 begin
    clk <= not clk after 10ns;
    p1: process
    begin
    wait UNTIL rising_edge(clk);
    if (max_min_calculation = '0') then
        cur_state <= 0;
    end if;
    if(max_min_calculation = '1' and normalisation_done = '0') then
        cur_state <= 1;
    end if;
    if(cur_state  = 1 and normalisation_done = '1') then
        cur_state <= 2;
    end if;
    end process;
 end architecture ; -- arch