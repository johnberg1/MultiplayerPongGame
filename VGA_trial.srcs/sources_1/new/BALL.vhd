library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE BALL IS
PROCEDURE CIRCLE(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);SIGNAL DRAW: OUT STD_LOGIC);
END BALL;

PACKAGE BODY BALL IS
PROCEDURE CIRCLE(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);SIGNAL DRAW: OUT STD_LOGIC) IS 
BEGIN
   IF( (Xcur-Xpos)*(Xcur-Xpos) + (Ycur-Ypos)*(Ycur-Ypos) < 100) THEN
        RGB<="1111";
        DRAW<='1';
        ELSE
        DRAW<='0';
   END IF;
END CIRCLE;
END BALL;