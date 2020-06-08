library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY VGA IS
PORT(
    CLOCK: IN STD_LOGIC ; --_VECTOR(1 downto 0);
    VGA_HS,VGA_VS:OUT STD_LOGIC;
    KEY: in STD_LOGIC_VECTOR(3 DOWNTO 0);
    SW: in STD_LOGIC;
    VGA_R,VGA_B,VGA_G: OUT STD_LOGIC_VECTOR(3 downto 0);
    Anode_Activate_o : out STD_LOGIC_VECTOR (3 downto 0);
    LED_out_o : out STD_LOGIC_VECTOR (6 downto 0)
 );
END VGA;


ARCHITECTURE MAIN OF VGA IS
SIGNAL VGACLK,RESET:STD_LOGIC;
 COMPONENT SYNC IS
 PORT(
	CLK: IN STD_LOGIC;
	HSYNC: OUT STD_LOGIC;
	VSYNC: OUT STD_LOGIC;
	R: OUT STD_LOGIC_VECTOR(3 downto 0);
	G: OUT STD_LOGIC_VECTOR(3 downto 0);
	B: OUT STD_LOGIC_VECTOR(3 downto 0);
	KEYS: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	S: IN STD_LOGIC;
	Anode_Activate : out STD_LOGIC_VECTOR (3 downto 0);
    LED_out : out STD_LOGIC_VECTOR (6 downto 0)
   );
END COMPONENT SYNC;
BEGIN

 C1: SYNC PORT MAP( CLK => CLOCK, HSYNC => VGA_HS, VSYNC => VGA_VS, R => VGA_R,G => VGA_G,B => VGA_B,KEYS => KEY, S => SW,
                    Anode_Activate => Anode_Activate_o, LED_out => LED_out_o);
 
 END MAIN;
 