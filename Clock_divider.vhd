
library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

entity Clock_divider is

    Port(clk_in: in std_logic;

         clk_out: out std_logic :='0');

end Clock_divider;

architecture Behavioral of Clock_divider is

    signal cur : std_logic := '0';

begin

    dividing:process(clk_in)

        variable counter: integer :=0;

    begin

        if(rising_edge(clk_in)) then

            if counter=0 then

                counter :=1;

            else

                counter :=0;

                clk_out <= Not cur;

                cur <= not cur;

            end if;

        end if;

    end process;

end Behavioral;


