library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity tb_clock_divider is
end tb_clock_divider;

architecture Behavioral of tb_clock_divider is
Component Clock_divider
port(
clk_in: IN std_logic;
clk_out : out std_logic
);
end component;
signal clock : std_logic :='0';
signal to_be_output : std_logic ;
constant clock_period : time := 10 ns;
begin
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;
cd1 : Clock_divider port map(
clk_in => clock,
clk_out => to_be_output 
);
t1:process (clock)
begin

end process;
end Behavioral;
