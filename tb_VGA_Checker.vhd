library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity vga_checker is
    Port (
        clk : inout std_logic := '0';
        hsync_signal : out std_logic:='1';
        vsync_signal : out std_logic:='1';
        red : out std_logic_vector(3 downto 0):= (others => '0');
        green : out std_logic_vector(3 downto 0):= (others => '0');
        blue: out std_logic_vector(3 downto 0):= (others => '0')
    );
end vga_checker;
architecture Behavioral of vga_checker is
    component Clock_Divider is

        port (

            clk_in : in std_logic;

            clk_out : out std_logic);

    end component;

    component FSM1 port(
            max_min_calculation : in std_logic := '0';
            clk : in std_logic;
            normalisation_done : in std_logic := '0';
            cur_state : inout integer := 0
        );
    end component;

    component FSM2 port(
            clk : IN STD_LOGIC := '0';
            state_from_fsm1 : IN INTEGER;
            max_min_calculation : inout std_logic := '0';
            normalisation_done : inout std_logic := '0';
            in_x : in integer ;
            in_y : in integer;
            val : out std_logic_vector(7 downto 0);
            counter_3 : out integer;
            max_out : out integer;
            min_out : out integer;
            data_to_ram_out : out std_logic_vector(7 downto 0);
            data_from_mac2_out : out std_logic_vector(15 downto 0)
        );
    end component;
    constant HACTIVE : integer :=640;
    constant HBACK : integer := 48;
    constant HSYNC : integer := 96;
    constant HFRONT : integer := 16;
    constant HTOT :  integer := HACTIVE + HFRONT + HBACK + HSYNC;
    constant VACTIVE : integer :=480;
    constant VFRONT : integer := 10;
    constant VBACK : integer := 33;
    constant VSYNC : integer := 2;
    signal hcnt : integer := 0;
    signal vcnt : integer := 0;
    signal pixelOn : std_logic := '0';
    signal out_clk : std_logic;
    signal help : std_logic:='1';
    constant VTOT :  integer := VACTIVE + VFRONT + VBACK + VSYNC;
    signal val_reader: std_logic_vector(3 downto 0):= (others => '0'); --To read the val from gradientoperator
    signal final :std_logic_vector(7 downto 0) :=(others => '0');
    signal max_min_calculation : std_logic :='0';
    signal normalisation_done : std_logic;
    signal state_from_fsm1 : integer ;
    signal counter_3 : integer;
    signal max_out : integer ;
    signal min_out : integer;
    signal data_to_ram : std_logic_vector(7 downto 0);
    signal data_from_mac2_out : std_logic_vector(15 downto 0);
begin

    clock_div : Clock_Divider port map(

            clk_in=>clk ,

            clk_out=>out_clk

        );

    fsm1_1 : FSM1 port map(
            clk => out_clk,
            max_min_calculation => max_min_calculation,
            normalisation_done => normalisation_done,
            cur_state => state_from_fsm1
        );
    fsm2_1 : FSM2 port map(
            clk => out_clk,
            state_from_fsm1 => state_from_fsm1,
            max_min_calculation => max_min_calculation,
            normalisation_done => normalisation_done,
            in_x => hcnt,
            in_y => vcnt,
            val => final,
            counter_3 => counter_3,
            max_out => max_out,
            min_out => min_out,
            data_to_ram_out => data_to_ram,
            data_from_mac2_out => data_from_mac2_out
        );
        clk <= not clk after 10ns;

    vertical_line_counter : process (out_clk, hcnt,help)

    begin

        if (help = '1') then

            if (rising_edge(out_clk)) then

                if (hcnt = (HTOT-1)) then

                    if (vcnt = (VTOT-1)) then

                        vcnt <=0;

                    else

                        vcnt <=vcnt + 1;

                    end if;

                end if;

            end if;

        end if;

    end process;

    horizontal_pixel_counter : process (out_clk,help)

    begin

        if (help ='1') then

            if (rising_edge(out_clk)) then

                if (hcnt = HTOT -1) then

                    hcnt <= 0;

                else

                    hcnt <= hcnt + 1;

                end if;

            end if;

        end if;

    end process;
    hsync_generator : process (out_clk,hcnt,help)

    begin

        if (help='1') then

            if (rising_edge(out_clk)) then

                if (hcnt<(HACTIVE+HFRONT) or hcnt>=(HACTIVE+HFRONT+HSYNC)) then

                    hsync_signal <= '1';

                else

                    hsync_signal <= '0';

                end if;

            end if;

        end if;

    end process;
    pixel_controller : process (out_clk , hcnt, vcnt, help)

    begin

        if (help = '1') then

            if (rising_edge(out_clk)) then

                if (hcnt<HACTIVE and vcnt<VACTIVE) then

                    pixelOn <='1';

                else

                    pixelOn <='0';

                end if;

            end if;



        end if;

    end process;
    vsync_gerberator : process (out_clk,vcnt,help)

    begin

        if (help ='1') then

            if (rising_edge(out_clk)) then

                if (vcnt<(VACTIVE+VFRONT) or vcnt>=(VACTIVE+VFRONT+VSYNC)) then

                    vsync_signal<='1';

                else

                    vsync_signal<='0';

                end if;

            end if;

        end if;

    end process;
    display : process (out_clk , hcnt , vcnt, pixelOn, help)

    begin

        if(rising_edge(out_clk)) then

            if (help = '1') then

                if (pixelOn = '1') then

                    if ( hcnt<64 and vcnt<64) then

                        red <= val_reader;

                        green <= val_reader;

                        blue <=val_reader;

                    else

                        red <="0000";

                        green<="0000";

                        blue<="0000";

                    end if;

                else

                    red<="0000";

                    green<="0000";

                    blue<="0000";

                end if;

            else

                red <="0000";

                green<="0000";

                blue<="0000";

            end if;

        end if;

    end process;


    val_reader(0)<=final(4);

    val_reader(1)<=final(5);

    val_reader(2)<=final(6);

    val_reader(3)<=final(7);

end Behavioral;
