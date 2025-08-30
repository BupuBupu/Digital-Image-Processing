
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
entity accu is
  port (
    clk : in std_logic;
    p : in integer;
    sm : inout integer := 0;
    ctrl : in integer
  ) ;
end accu ;

architecture Behaviour of accu is

begin

    process
    begin
        wait until rising_edge(clk);
        if (ctrl = 0) then
            sm <= sm + p ;
        elsif ctrl = 1 then
            sm <= p;
        elsif ctrl =2 then
          sm <= sm;
        end if;
    end process;


end architecture ; -- Behaviour