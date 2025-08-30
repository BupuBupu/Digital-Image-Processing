LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
entity MUL is
  port (
    a1 : in std_logic_vector(7 downto 0);
    a2 : in std_logic_vector(7 downto 0);
    b : out integer
  ) ;
end MUL ;

architecture Behaviour of MUL is



begin

    b <= to_integer(unsigned(a1)) * to_integer(signed(a2));

end architecture ; -- Behaviour