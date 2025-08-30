LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
ENTITY MAC IS
    PORT (
        clk : IN STD_LOGIC;
        CTRL : IN integer;
        a1 : in std_logic_vector(7 downto 0);
        a2 : in std_logic_vector(7 downto 0);
        output : out std_logic_vector(15 downto 0)
    );
END MAC;

ARCHITECTURE Behaviour OF MAC IS

    signal b : integer := 0;
    signal c : integer := 0;
    component accu port(
    clk : in std_logic;
    p : in integer;
    sm : inout integer := 0;
    ctrl : in integer
    );
    end component;
    component mul port(
    a1 : in std_logic_vector(7 downto 0);
    a2 : in std_logic_vector(7 downto 0);
    b : out integer
    );
    end component;
BEGIN
    output <= std_logic_vector(to_signed(c,16));
    UUT2: MUL
    port map (
    a1 => a1,
    a2 => a2,
    b => b
    );
    UUT1: accu
    port map (
        clk => clk,
        p => b,
        sm => c,
        ctrl => CTRL
    );
END ARCHITECTURE; -- Behaviour