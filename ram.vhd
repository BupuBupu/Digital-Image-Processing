----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2023 01:30:06 AM
-- Design Name: 
-- Module Name: ram - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram is
  Port ( 
      we_to_ram : in std_logic;
      address :  in std_logic_vector (11 downto 0);
      d : in std_logic_vector(7 downto 0);
      spo : out std_logic_vector(7 downto 0);
      clk : in std_logic
 );
end ram;

architecture Behavioral of ram is

COMPONENT RAM_0

        PORT(

            a : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            d : in std_logic_vector (7 downto 0);
            clk : in std_logic;
            we : in std_logic

        );
end component;

signal address_to_ram : std_logic_vector (11 downto 0);
signal data_to_ram : std_logic_vector (7 downto 0);
signal step : integer :=0;
signal data_from_ram : std_logic_vector(7 downto 0):=(others=>'0');
begin
ram : RAM_0 port map(
    a => address_to_ram,
    spo => data_from_ram,
    d => data_to_ram,
    clk => clk,
    we => we_to_ram
 );
 
 p1 : process
 begin
 wait until rising_edge (clk);
 if(we_to_ram = '1') then
       if step =0 then
        address_to_ram <= address;
        data_to_ram <= d;
        step <= step +1;
       else 
        step <= 0;
       end if;
    
 else
      spo <= data_from_ram;
      address_to_ram <= address;        
 end if;
 end process;
end Behavioral;
