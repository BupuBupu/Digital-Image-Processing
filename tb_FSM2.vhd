
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY FSM2 IS
    PORT (
        clk : INOUT STD_LOGIC := '0'; --Updated
        state_from_fsm1 : IN INTEGER :=0; --updated
        max_min_calculation : inout std_logic := '0';
        normalisation_done : inout std_logic := '0';
        in_x : in integer :=0 ;
        in_y : in integer:=0; --updated
        val : out std_logic_vector(7 downto 0);
        counter_3 : out integer;
        max_out : out integer;
        min_out : out integer;
        signal data_to_ram_out : out std_logic_vector(7 downto 0);
        signal data_from_mac2_out : out std_logic_vector(15 downto 0)
    );
END FSM2;

ARCHITECTURE arch OF FSM2 IS
    
    component ram port(
      we_to_ram : in std_logic ;
      address :  in std_logic_vector (11 downto 0);
      d : in std_logic_vector(7 downto 0);
      spo : out std_logic_vector(7 downto 0);
      clk : in std_logic    
    );
    end component;
    component Filter_Rom port(
         a: in std_logic_vector(3 downto 0);
         spo : out std_logic_vector(7 downto 0)
    );
    end component; 
    component dist_mem_gen_0 port(
        a : in std_logic_vector (11 downto 0);
        spo : out std_logic_vector(7 downto 0)
    );
    end component;
    component MAC port(
        clk : IN STD_LOGIC;
        CTRL : IN integer;
        a1 : in std_logic_vector(7 downto 0);
        a2 : in std_logic_vector(7 downto 0);
        output : out std_logic_vector(15 downto 0)
    );
    end component;
    component registe port(
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
    );
    end component;
    signal counter_1 : integer := 0 ;
    signal state : integer := 0 ;
    signal we_to_ram : std_logic :='1';
    signal data_from_rom_kernel : std_logic_vector (7 downto 0) ;
    signal address_to_rom_kernel : std_logic_vector (3 downto 0) ;
    signal address_to_rom_coe : std_logic_vector (11 downto 0);
    signal data_from_rom_coe : std_logic_vector (7 downto 0) ;
    signal max : integer := 0 ;
    signal min : integer := 16384 ;
    signal counter_2 : integer := 0 ;
    signal state_1 : integer := 0 ;
    signal data_to_ram : std_logic_vector(7 downto 0);
    signal address_to_ram : std_logic_vector( 11 downto 0);
    signal    we_to_reg1 :  STD_LOGIC;
    signal        we_to_reg2 :  STD_LOGIC;
    signal    we_to_reg4 :  STD_LOGIC;
    signal        we_to_reg3 :  STD_LOGIC;
    signal     data1_to_mac_1 :  std_logic_vector (7 downto 0);
    signal      data2_to_mac_1 :  std_logic_vector (7 downto 0);
    signal     data1_to_mac_2 :  std_logic_vector (7 downto 0);
     signal      data2_to_mac_2 :  std_logic_vector (7 downto 0);
      signal      data_from_mac_1 :  std_logic_vector(15 downto 0);
      signal      data_from_mac_2 :  std_logic_vector(15 downto 0);
      signal      re1_for_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal       re1_from_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal       re2_for_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal       re2_from_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal       re3_for_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal    re3_from_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal       re4_for_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
      signal      re4_from_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal       re5_for_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
      signal      re5_from_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal      re6_for_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re6_from_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re7_for_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re7_from_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
      signal  re8_for_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re8_from_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
 signal       re9_for_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re9_from_reg1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re1_for_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal   re1_from_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re2_for_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal      re2_from_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re3_for_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re3_from_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re4_for_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal      re4_from_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal   re5_for_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal   re5_from_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal   re6_for_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal   re6_from_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal      re7_for_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re7_from_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re8_for_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re8_from_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re9_for_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re9_from_reg2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal      re1_for_reg3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
 signal       re1_from_reg3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
 signal       re2_for_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
 signal       re2_from_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
 signal       re3_for_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
 signal    re3_from_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
 signal       re4_for_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal      re4_from_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
 signal       re5_for_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal      re5_from_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal      re6_for_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re6_from_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re7_for_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re7_from_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
      signal  re8_for_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re8_from_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
 signal       re9_for_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re9_from_reg3:  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re1_for_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal   re1_from_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re2_for_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal      re2_from_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re3_for_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re3_from_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re4_for_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal      re4_from_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal   re5_for_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal   re5_from_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal   re6_for_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal   re6_from_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal      re7_for_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re7_from_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re8_for_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re8_from_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    re9_for_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
   signal     re9_from_reg4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
     signal   cntrl_1 :  integer ;
     signal   cntrl_2 :  integer ;
     signal two_5_5 : integer := 255;
   signal data_from_ram : std_logic_vector(7 downto 0);
   signal address_to_ram_for_reading : std_logic_vector( 11 downto 0);
   signal address_to_ram_for_writing : std_logic_vector( 11 downto 0);
   signal address_to_romkernel_for_reading_1 : integer;
   signal address_to_romcoe_for_reading_1 : integer;
   signal address_to_romkernel_for_reading_2 : integer;
   signal address_to_romcoe_for_reading_2 : integer;
   signal  address_to_romcoe_for_reading3 : integer;  
   signal state_from_fsm1_in: integer;
   
    -- signal date_from_mac_internal : std_logic_vector (15 downto 0);
BEGIN
    -- initialsiation for ram
       
    -- initialisation for rom_kernel
    -- initialisation for rom_coe
    -- initialisation for register;
    -- initialisations for mac; data_from_reg1 and data_from_reg2 have to appropriately mapped with mac ports;
    kernel_1 : Filter_Rom port map(
        a => address_to_rom_kernel, 
        spo => data_from_rom_kernel
    ); 
    rom_coe_1 : dist_mem_gen_0 port map (
        a => address_to_rom_coe,
        spo => data_from_rom_coe
    );
    ram1 : ram port map(
      we_to_ram => we_to_ram, 
      address => address_to_ram,  
      d => data_to_ram,
      spo => data_from_ram,
      clk  => clk
    );
--    coe_rom : rom_coe port map(
--    address => address_to_rom_coe,
--    data_out_from_coe => data_from_rom_coe,
--    clk => clk
--    ); 
    mac1: MAC port map(
        clk => clk,
        CTRL => cntrl_1,
        a2 => data1_to_mac_1,
        a1 => data2_to_mac_1,
        output => data_from_mac_1
    );
    mac2 : MAC port map(
        clk => clk,
        CTRL => cntrl_2,
        a2 => data1_to_mac_2,
        a1 => data2_to_mac_2,
        output => data_from_mac_2      
    );
    reg1 : registe port map(
    we => we_to_reg1,
    clk => clk,
    re1_out => re1_from_reg1,
    re2_out => re2_from_reg1,
    re3_out => re3_from_reg1,
    re4_out => re4_from_reg1,
    re5_out => re5_from_reg1,
    re6_out => re6_from_reg1,
    re7_out => re7_from_reg1,
    re8_out => re8_from_reg1,
    re9_out => re9_from_reg1,
    re1_in => re1_for_reg1,
    re2_in => re2_for_reg1,
    re3_in => re3_for_reg1,
    re4_in => re4_for_reg1,
    re5_in => re5_for_reg1,
    re6_in => re6_for_reg1,
    re7_in => re7_for_reg1,
    re8_in => re8_for_reg1,
    re9_in => re9_for_reg1
    );
    
    reg2 : registe port map(
    we => we_to_reg2,
    clk => clk,
    re1_out => re1_from_reg2,
    re2_out => re2_from_reg2,
    re3_out => re3_from_reg2,
    re4_out => re4_from_reg2,
    re5_out => re5_from_reg2,
    re6_out => re6_from_reg2,
    re7_out => re7_from_reg2,
    re8_out => re8_from_reg2,
    re9_out => re9_from_reg2,
    re1_in => re1_for_reg2,
    re2_in => re2_for_reg2,
    re3_in => re3_for_reg2,
    re4_in => re4_for_reg2,
    re5_in => re5_for_reg2,
    re6_in => re6_for_reg2,
    re7_in => re7_for_reg2,
    re8_in => re8_for_reg2,
    re9_in => re9_for_reg2
    );
    reg3 : registe port map(
    we => we_to_reg3,
    clk => clk,
    re1_out => re1_from_reg3,
    re2_out => re2_from_reg3,
    re3_out => re3_from_reg3,
    re4_out => re4_from_reg3,
    re5_out => re5_from_reg3,
    re6_out => re6_from_reg3,
    re7_out => re7_from_reg3,
    re8_out => re8_from_reg3,
    re9_out => re9_from_reg3,
    re1_in => re1_for_reg3,
    re2_in => re2_for_reg3,
    re3_in => re3_for_reg3,
    re4_in => re4_for_reg3,
    re5_in => re5_for_reg3,
    re6_in => re6_for_reg3,
    re7_in => re7_for_reg3,
    re8_in => re8_for_reg3,
    re9_in => re9_for_reg3
    );
    
    reg4 : registe port map(
    we => we_to_reg4,
    clk => clk,
    re1_out => re1_from_reg4,
    re2_out => re2_from_reg4,
    re3_out => re3_from_reg4,
    re4_out => re4_from_reg4,
    re5_out => re5_from_reg4,
    re6_out => re6_from_reg4,
    re7_out => re7_from_reg4,
    re8_out => re8_from_reg4,
    re9_out => re9_from_reg4,
    re1_in => re1_for_reg4,
    re2_in => re2_for_reg4,
    re3_in => re3_for_reg4,
    re4_in => re4_for_reg4,
    re5_in => re5_for_reg4,
    re6_in => re6_for_reg4,
    re7_in => re7_for_reg4,
    re8_in => re8_for_reg4,
    re9_in => re9_for_reg4
    );
    counter_3 <= counter_1;
    max_out <= max;
    min_out <= min;
    state_from_fsm1_in<= state_from_fsm1;
    data_to_ram_out <= data_to_ram;
    data_from_mac2_out <= data_from_mac_2;
    clk<= not clk after 10ns;
    p1 : PROCESS -- the process for state=0
    BEGIN
        WAIT UNTIL rising_edge(clk);
        IF (state_from_fsm1_in = 0) THEN
            if(counter_1 <= 4095) then
                if(state = 0 ) then
                    we_to_reg1 <= '1';
                    we_to_reg2 <= '1';
                    address_to_romkernel_for_reading_1 <= 0;
                    if counter_1- 65 >=0 and counter_1-65 < 4096 then
                    address_to_romcoe_for_reading_1 <= counter_1-65;
                    end if;
                    state <= state+1;
                elsif state = 1 then
                    state <= state+1;
                elsif state = 2 then
                    re1_for_reg1 <= data_from_rom_kernel;
                    if counter_1- 65 >=0 and counter_1-65 < 4096 then
                    re1_for_reg2 <= data_from_rom_coe;
                    else 
                    re1_for_reg2 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state <= state+1;
                elsif state =3 then
                    address_to_romkernel_for_reading_1 <= 1;
                    if counter_1 - 64 >=0 and counter_1 -  64 < 4096 then
                    address_to_romcoe_for_reading_1 <= counter_1-64;
                    end if;
                    state <= state + 1;
                elsif state =4 then
                    state <= state+1;
                elsif state =5 then
                    re2_for_reg1 <= data_from_rom_kernel;
                    if counter_1- 64 >=0 and counter_1-64 < 4096 then
                    re2_for_reg2 <= data_from_rom_coe;
                    else 
                    re2_for_reg2 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state <= state+1;
                elsif state = 6 then
                    address_to_romkernel_for_reading_1 <= 2;
                    if counter_1 - 63 >=0 and counter_1 -63 < 4096 then
                    address_to_romcoe_for_reading_1 <= counter_1-63;
                    end if;
                    state <= state + 1;
                elsif state = 7 then
                    state <= state+1;
                elsif state = 8 then
                    re3_for_reg1 <= data_from_rom_kernel;
                    if counter_1 -63 >=0 and counter_1 - 63 <4096 then
                    re3_for_reg2 <= data_from_rom_coe;
                    else 
                    re3_for_reg2 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state <= state+1;
                elsif state = 9 then
                    address_to_romkernel_for_reading_1 <= 3;
                    if counter_1 -1 >=0 and counter_1-1<4096 then
                    address_to_romcoe_for_reading_1 <= counter_1-1;
                    end if;
                    state <= state + 1;
                elsif state = 10 then
                    state <= state+1;
                elsif state =11 then
                    
                    re4_for_reg1 <= data_from_rom_kernel;
                    if counter_1-1>=0 and counter_1-1<4096 then
                        re4_for_reg2 <= data_from_rom_coe;
                    else
                        re4_for_reg2 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state <= state+1;
                elsif state = 12 then
                    address_to_romkernel_for_reading_1 <= 4;
                    if counter_1>=0 and counter_1<4096 then 
                        address_to_romcoe_for_reading_1 <= counter_1;
                    end if;
                    state <= state + 1;
                elsif state = 13 then
                    state <= state+1;
                elsif state <= 14 then
                    re5_for_reg1 <= data_from_rom_kernel;
                    if counter_1>=0 and counter_1<4096 then
                        re5_for_reg2 <= data_from_rom_coe;
                    else
                        re5_for_reg2 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state <= state + 1;
                elsif state = 15 then
                    address_to_romkernel_for_reading_1 <= 5;
                    if counter_1+1>=0 and counter_1 +1 <4096 then 
                        address_to_romcoe_for_reading_1 <= counter_1 + 1;
                    end if;
                    state <= state + 1;
                elsif state = 16 then
                    state <= state +1;
                elsif  state = 17 then
                    re6_for_reg1 <= data_from_rom_kernel;
                    if counter_1+1>=0 and counter_1+1<4096 then
                        re6_for_reg2 <= data_from_rom_coe;
                    else
                        re6_for_reg2 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state <= state + 1;
                elsif state = 18 then
                    address_to_romkernel_for_reading_1 <= 6;
                    if counter_1 +63 >=0 and counter_1<4096 then 
                        address_to_romcoe_for_reading_1 <= counter_1 + 63;
                    end if;
                    state <= state + 1;
                elsif state = 19 then
                    state <= state+1;
                elsif state =20 then
                    re7_for_reg1 <= data_from_rom_kernel;
                    if counter_1 +63>= 0 and counter_1+63 <4096 then 
                        re7_for_reg2 <= data_from_rom_coe;
                    else
                        re7_for_reg2 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state <= state+1;
                elsif state = 21 then
                    address_to_romkernel_for_reading_1 <= 7;
                    if counter_1 +64 >=0 and counter_1 +64 <4096 then
                        address_to_romcoe_for_reading_1 <= counter_1 + 64;
                    end if;
                    state <= state + 1;
                elsif state = 22 then
                    state <= state+1;
                elsif state = 23 then
                    re8_for_reg1 <= data_from_rom_kernel;
                    if counter_1 +64 >=0 and counter_1+64<4096 then 
                        re8_for_reg2 <= data_from_rom_coe;
                    else
                        re8_for_reg2 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state <= state+1;
                elsif state = 24 then
                    address_to_romkernel_for_reading_1 <= 8;
                    if counter_1+65  >=0 and counter_1+65 <4096 then 
                        address_to_romcoe_for_reading_1 <= counter_1+65;
                    end if;
                    state <= state + 1;
                elsif state = 25 then
                    state <= state+1;
                elsif state = 26 then
                    re9_for_reg1 <= data_from_rom_kernel;
                    if counter_1 +65 >=0 and counter_1 +65<4096 then 
                        re9_for_reg2 <= data_from_rom_coe;
                    else
                     re9_for_reg2 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state <= state+1;
                elsif state = 27 then
                    we_to_reg1 <= '0';
                    we_to_reg2 <= '0';
                    cntrl_1 <= 1;
                    data1_to_mac_1 <= std_logic_vector (to_unsigned(0,8));
                    data2_to_mac_1 <= std_logic_vector (to_unsigned(0,8));
                    state <= state +1;
                elsif state = 28 then
                    state <= state+1;
                elsif state = 29 then
                    cntrl_1 <= 0;
                    data1_to_mac_1 <= re1_from_reg1;
                    data2_to_mac_1 <= re1_from_reg2;
                    state  <= state + 1;
                elsif state = 30 then
                    cntrl_1 <= 0;
                    data1_to_mac_1 <= re2_from_reg1;
                    data2_to_mac_1 <= re2_from_reg2;
                    state  <= state + 1;
                elsif state = 31 then
                    cntrl_1 <= 0;
                    data1_to_mac_1 <= re3_from_reg1;
                    data2_to_mac_1 <= re3_from_reg2;
                    state  <= state + 1;
                elsif state = 32 then
                    cntrl_1 <= 0;
                    data1_to_mac_1 <= re4_from_reg1;
                    data2_to_mac_1 <= re4_from_reg2;
                    state  <= state + 1;
                elsif state = 33 then
                    cntrl_1 <= 0;
                    data1_to_mac_1 <= re5_from_reg1;
                    data2_to_mac_1 <= re5_from_reg2;
                    state  <= state + 1;
                elsif state = 34 then
                    cntrl_1 <= 0;
                    data1_to_mac_1 <= re6_from_reg1;
                    data2_to_mac_1 <= re6_from_reg2;
                    state  <= state + 1;
                elsif state = 35 then
                    cntrl_1 <= 0;
                    data1_to_mac_1 <= re7_from_reg1;
                    data2_to_mac_1 <= re7_from_reg2;
                    state  <= state + 1;
                elsif state = 36 then
                    cntrl_1 <= 0;
                    data1_to_mac_1 <= re8_from_reg1;
                    data2_to_mac_1 <= re8_from_reg2;
                    state <= state+1;
                elsif state = 37 then
                    cntrl_1 <= 0;
                    data1_to_mac_1 <= re9_from_reg1;
                    data2_to_mac_1 <= re9_from_reg2;
                    state <= state+1;
                elsif state = 38 then
                    cntrl_1 <= 2 ;
                    state <= state + 1 ;
                elsif state = 39 then
                    if max < to_integer(signed(data_from_mac_1)) then
                        max <= to_integer(signed(data_from_mac_1));
                    end if;
                    if min > to_integer(signed(data_from_mac_1)) then
                        min <= to_integer(signed(data_from_mac_1));
                    end if;
                    counter_1 <= counter_1 + 1;
                    state <= 0;
                end if;
            else
                max_min_calculation <= '1';
            end if;
        END IF;
    END PROCESS;
    p2 : process --state_from_fsm1- the process for state = 1
    begin
        wait until rising_edge(clk);
        if(state_from_fsm1 = 1) then
            if(counter_2 <= 4095) then
                if(state_1 = 0 ) then
                    we_to_reg3 <= '1';
                    we_to_reg4 <= '1';
                    address_to_romkernel_for_reading_2 <= 0;
                    if counter_2- 65 >=0 and counter_2-65 < 4096 then
                    address_to_romcoe_for_reading_2 <= counter_2-65;
                    end if;
                    state_1 <= state_1+1;
                elsif state_1 = 1 then
                    state_1 <= state_1+1;
                elsif state_1 = 2 then
                    re1_for_reg3 <= data_from_rom_kernel;
                    if counter_2- 65 >=0 and counter_2-65 < 4096 then
                    re1_for_reg4 <= data_from_rom_coe;
                    else 
                    re1_for_reg4 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state_1 <= state_1+1;
                elsif state_1 =3 then
                    address_to_romkernel_for_reading_2 <= 1;
                    if counter_2 - 64 >=0 and counter_2 -  64 < 4096 then
                    address_to_romcoe_for_reading_2 <= counter_2-64;
                    end if;
                    state_1 <= state_1 + 1;
                elsif state_1 =4 then
                    state_1 <= state_1+1;
                elsif state_1 =5 then
                    re2_for_reg3 <= data_from_rom_kernel;
                    if counter_2- 64 >=0 and counter_2-64 < 4096 then
                    re2_for_reg4 <= data_from_rom_coe;
                    else 
                    re2_for_reg4 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state_1 <= state_1+1;
                elsif state_1 = 6 then
                    address_to_romkernel_for_reading_2 <= 2;
                    if counter_2 - 63 >=0 and counter_2 -63 < 4096 then
                    address_to_romcoe_for_reading_2 <= counter_2-63;
                    end if;
                    state_1 <= state_1 + 1;
                elsif state_1 = 7 then
                    state_1 <= state_1+1;
                elsif state_1 = 8 then
                    re3_for_reg3 <= data_from_rom_kernel;
                    if counter_2 -63 >=0 and counter_2 - 63 <4096 then
                    re3_for_reg4 <= data_from_rom_coe;
                    else 
                    re3_for_reg4 <= std_logic_vector(to_unsigned(0,8)); 
                    end if;
                    state_1 <= state_1+1;
                elsif state_1 = 9 then
                    address_to_romkernel_for_reading_2 <= 3;
                    if counter_2 -1 >=0 and counter_2-1<4096 then
                    address_to_romcoe_for_reading_2 <= counter_2-1;
                    end if;
                    state_1 <= state_1 + 1;
                elsif state_1 = 10 then
                    state_1 <= state_1+1;
                elsif state_1 =11 then
                    re4_for_reg3 <= data_from_rom_kernel;
                    if counter_2-1>=0 and counter_2-1<4096 then
                        re4_for_reg4 <= data_from_rom_coe;
                    else
                        re4_for_reg4 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state_1 <= state_1+1;
                elsif state_1 = 12 then
                    address_to_romkernel_for_reading_2 <= 4;
                    address_to_romcoe_for_reading_2 <= counter_2;
                    state_1 <= state_1 + 1;
                elsif state_1 = 13 then
                    state_1 <= state_1+1;
                elsif state_1 <= 14 then
                    re5_for_reg3 <= data_from_rom_kernel;
                    re5_for_reg4<= data_from_rom_coe;
                    state_1 <= state_1 + 1;
                elsif state_1 = 15 then
                    address_to_romkernel_for_reading_2 <= 5;
                    if counter_2+1>=0 and counter_2 +1 <4096 then 
                        address_to_romcoe_for_reading_2 <= counter_2 + 1;
                    end if;
                    state_1 <= state_1 + 1;
                elsif state_1 = 16 then
                    state_1 <= state_1 +1;
                elsif  state_1 = 17 then
                    re6_for_reg3 <= data_from_rom_kernel;
                    if counter_2+1>=0 and counter_2+1<4096 then
                        re6_for_reg4 <= data_from_rom_coe;
                    else
                        re6_for_reg4 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state_1 <= state_1 + 1;
                elsif state_1 = 18 then
                    address_to_romkernel_for_reading_2 <= 6;
                    if counter_2 +63 >=0 and counter_2<4096 then 
                        address_to_romcoe_for_reading_2 <= counter_2 + 63;
                    end if;
                    state_1 <= state_1 + 1;
                elsif state_1 = 19 then
                    state_1 <= state_1+1;
                elsif state_1 =20 then
                    re7_for_reg3 <= data_from_rom_kernel;
                    if counter_2 +63>= 0 and counter_2+63 <4096 then 
                        re7_for_reg4 <= data_from_rom_coe;
                    else
                        re7_for_reg4 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state_1 <= state_1+1;
                elsif state_1 = 21 then
                    address_to_romkernel_for_reading_2 <= 7;
                    if counter_2 +64 >=0 and counter_2 +64 <4096 then
                        address_to_romcoe_for_reading_2 <= counter_2 + 64;
                    end if;
                    state_1 <= state_1 + 1;
                elsif state_1 = 22 then
                    state_1 <= state_1+1;
                elsif state_1 = 23 then
                    re8_for_reg3 <= data_from_rom_kernel;
                    if counter_2 +64 >=0 and counter_2+64<4096 then 
                        re8_for_reg4 <= data_from_rom_coe;
                    else
                        re8_for_reg4 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state_1 <= state_1+1;
                elsif state_1 = 24 then
                    address_to_romkernel_for_reading_2 <= 8;
                    if counter_2+65  >=0 and counter_2+65 <4096 then 
                        address_to_romcoe_for_reading_2 <= counter_2+65;
                    end if;
                    state_1 <= state_1 + 1;
                elsif state_1 = 25 then
                    state_1 <= state_1+1;
                elsif state_1 = 26 then
                    re9_for_reg3 <= data_from_rom_kernel;
                    if counter_2 +65 >=0 and counter_2 +65<4096 then  
                        re9_for_reg4 <= data_from_rom_coe;
                    else
                     re9_for_reg4 <= std_logic_vector(to_unsigned(0,8));
                    end if;
                    state_1 <= state_1+1;
                elsif state_1 = 27 then
                    we_to_reg3 <= '0';
                    we_to_reg4 <= '0';
                    cntrl_2 <= 1;
                    data1_to_mac_2 <= std_logic_vector (to_unsigned(0,8));
                    data2_to_mac_2 <= std_logic_vector (to_unsigned(0,8));
                    state_1 <= state_1 +1;
                elsif state_1 = 28 then
                    state_1 <= state_1+1;
                elsif state_1 = 29 then
                    cntrl_2 <= 0;
                    data1_to_mac_2 <= re1_from_reg3;
                    data2_to_mac_2 <= re1_from_reg4;
                    state_1  <= state_1 + 1;
                elsif state_1 = 30 then
                    cntrl_2 <= 0;
                    data1_to_mac_2 <= re2_from_reg3;
                    data2_to_mac_2 <= re2_from_reg4;
                    state_1  <= state_1 + 1;
                elsif state_1 = 31 then
                    cntrl_2 <= 0;
                    data1_to_mac_2 <= re3_from_reg3;
                    data2_to_mac_2 <= re3_from_reg4;
                    state_1  <= state_1 + 1;
                elsif state_1 = 32 then
                    cntrl_2 <= 0;
                    data1_to_mac_2 <= re4_from_reg3;
                    data2_to_mac_2 <= re4_from_reg4;
                    state_1  <= state_1 + 1;
                elsif state_1 = 33 then
                    cntrl_2 <= 0;
                    data1_to_mac_2 <= re5_from_reg3;
                    data2_to_mac_2 <= re5_from_reg4;
                    state_1  <= state_1 + 1;
                elsif state_1 = 34 then
                    cntrl_2 <= 0;
                    data1_to_mac_2 <= re6_from_reg3;
                    data2_to_mac_2 <= re6_from_reg4;
                    state_1  <= state_1 + 1;
                elsif state_1 = 35 then
                    cntrl_2 <= 0;
                    data1_to_mac_2 <= re7_from_reg3;
                    data2_to_mac_2 <= re7_from_reg4;
                    state_1  <= state_1 + 1;
                elsif state_1 = 36 then
                    cntrl_2 <= 0;
                    data1_to_mac_2 <= re8_from_reg3;
                    data2_to_mac_2 <= re8_from_reg4;
                    state_1 <= state_1+1;
                elsif state_1 = 37 then
                    cntrl_2 <= 0;
                    data1_to_mac_2 <= re9_from_reg3;
                    data2_to_mac_2 <= re9_from_reg4;
                    state_1 <= state_1+1;
                elsif state_1 = 38 then
                    cntrl_2 <= 2 ;
                    state_1 <= state_1 +1;
                elsif state_1 =39 then
                    address_to_ram_for_writing <= std_logic_vector(TO_UNSIGNED(counter_2,12));
                    data_to_ram <= std_logic_vector(to_unsigned((((to_integer(signed(data_from_mac_2))-min)* two_5_5) / (max - min)),8));
                    state_1 <= state_1 + 1 ;
                elsif state_1 = 40 then
                    state_1 <= state_1 +1 ;
                elsif state_1 = 41 then
                    state_1 <= state_1+1 ;
                elsif state_1 = 42 then
                    state_1 <= state_1 +1;
                elsif state_1 = 43 then
                    state_1 <= 0;
                    counter_2 <= counter_2 + 1;
                end if;
            else
            normalisation_done <= '1';
            we_to_ram <= '0';
            end if;
        end if;
    end process;
    p3 : process
    begin
        wait until rising_edge(clk);
        if(state_from_fsm1 =2 ) then
            if(in_x < 64 and in_y < 64) then
                address_to_ram_for_reading <= std_logic_vector(to_unsigned(in_x + in_y*64,12));
            end if;
        end if;
    end process;
    p4 : process 
    begin
    wait until rising_edge(clk);
    if(normalisation_done = '0') then
        address_to_ram <= address_to_ram_for_writing;
    else
        address_to_ram <= address_to_ram_for_reading;
    end if;
    end process;
    p6 : process 
    begin
    wait until rising_edge(clk);
    if(state_from_fsm1 = 2) then
        val <= data_from_ram ;
    end if;
    end process;
    p5 : process 
    begin
    wait until rising_edge(clk);
    
    if(state_from_fsm1 = 0) then
        address_to_rom_kernel <= std_logic_vector(to_unsigned(address_to_romkernel_for_reading_1,4));
        address_to_rom_coe <= std_logic_vector(to_unsigned(address_to_romcoe_for_reading_1,12)); 
    elsif state_from_fsm1 =1 then
        address_to_rom_kernel <= std_logic_vector(to_unsigned(address_to_romkernel_for_reading_2,4));
        address_to_rom_coe <= std_logic_vector(to_unsigned(address_to_romcoe_for_reading_2,12));
    else
        address_to_rom_coe <= std_logic_vector(to_unsigned(address_to_romcoe_for_reading3,12));
    end if;
    
    end process;
END ARCHITECTURE; -- arch
