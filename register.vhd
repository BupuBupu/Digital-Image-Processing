LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
 entity registe is
   port (
    we : in std_logic ;
    clk : in std_logic ;
    re1_out : out std_logic_vector (7 downto 0) ;
    re2_out : out std_logic_vector (7 downto 0) ;
    re3_out : out std_logic_vector (7 downto 0);
    re4_out : out std_logic_vector (7 downto 0);
    re5_out : out std_logic_vector (7 downto 0);
    re6_out : out std_logic_vector (7 downto 0);
    re7_out : out std_logic_vector (7 downto 0);
    re8_out : out std_logic_vector (7 downto 0);
    re9_out : out std_logic_vector (7 downto 0);
    re1_in : in std_logic_vector (7 downto 0) ;
    re2_in : in std_logic_vector (7 downto 0) ;
    re3_in : in std_logic_vector (7 downto 0);
    re4_in : in std_logic_vector (7 downto 0);
    re5_in : in std_logic_vector (7 downto 0);
    re6_in : in std_logic_vector (7 downto 0);
    re7_in : in std_logic_vector (7 downto 0);
    re8_in : in std_logic_vector (7 downto 0);
    re9_in : in std_logic_vector (7 downto 0)
    ) ;
 end registe ;

 architecture arch of registe is

    signal re1 : std_logic_vector(7 downto 0);
    signal re2 : std_logic_vector(7 downto 0);
    signal re3 : std_logic_vector(7 downto 0);
    signal re4 : std_logic_vector(7 downto 0);
    signal re5 : std_logic_vector(7 downto 0);
    signal re6 : std_logic_vector(7 downto 0);
    signal re7 : std_logic_vector(7 downto 0);
    signal re8 : std_logic_vector(7 downto 0);
    signal re9 : std_logic_vector(7 downto 0);

 begin
    p1 :process
    begin
        wait UNTIL rising_edge(clk);
        if(we = '0') then
            re1_out <= re1;
            re2_out <= re2;
            re3_out <= re3;
            re4_out <= re4;
            re5_out <= re5;
            re6_out <= re6;
            re7_out <= re7;
            re8_out <= re8;
            re9_out <= re9;

        else
            re1 <= re1_in;
            re2 <= re2_in;
            re3 <= re3_in;
            re4 <= re4_in;
            re5 <= re5_in;
            re6 <= re6_in;
            re7 <= re7_in;
            re8 <= re8_in;
            re9 <= re9_in;
        end if;
    end process;


 end architecture ; -- arch