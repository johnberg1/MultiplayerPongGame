library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my.all;
use work.ball.all;
use ieee.std_logic_unsigned.all;

ENTITY SYNC IS
PORT(
CLK: IN STD_LOGIC;
HSYNC: OUT STD_LOGIC;
VSYNC: OUT STD_LOGIC;
CLK_MOVE: INOUT STD_LOGIC;
R: OUT STD_LOGIC_VECTOR(3 downto 0);
G: OUT STD_LOGIC_VECTOR(3 downto 0);
B: OUT STD_LOGIC_VECTOR(3 downto 0);
KEYS: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
S: IN STD_LOGIC;
Anode_Activate : out STD_LOGIC_VECTOR (3 downto 0);
LED_out : out STD_LOGIC_VECTOR (6 downto 0)
);
END SYNC;


ARCHITECTURE MAIN OF SYNC IS

SIGNAL RGB: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL SQ_X1: INTEGER RANGE 464 TO 1904:= 1084;  --X coordinate of the first paddle
SIGNAL SQ_X2: INTEGER RANGE 464 TO 1904:= 1084;  --X coordinate of the second paddle
SIGNAL SQ_Y1: INTEGER RANGE 34 TO 934:= 104;  --Y coordinate of the first paddle
SIGNAL SQ_Y2: INTEGER RANGE 34 TO 934:= 844;  --Y coordinate of the second paddle
SIGNAL DRAW1,DRAW2,DRAW3,DRAW4,DRAW5,DRAW6:STD_LOGIC:='0';
SIGNAL HPOS: INTEGER RANGE 0 TO 1904:=0;
SIGNAL VPOS: INTEGER RANGE 0 TO 932:=0;
SIGNAL BALL_X: INTEGER RANGE 464 TO 1904:= 1184;  --X coordinate of the ball
SIGNAL BALL_Y: INTEGER RANGE 34 TO 934:= 494;  --Y coordinate of the ball

signal temp : STD_LOGIC:='0';
signal count: integer range 0 to 1000000000;
signal ballSpeedX : integer range -100 to 100 := 8;
signal ballSpeedY : integer range -100 to 100 := 9;
signal resetBall : STD_LOGIC := '0';
signal topLifes: integer range 0 to 7:= 7;
signal bottomLifes: integer range 0 to 7:= 7;
signal gameOver : STD_LOGIC := '0';
signal counter: integer range 0 to 10000000:= 0;
SIGNAL OB_X1: INTEGER RANGE 464 TO 1904;
SIGNAL OB_Y1: INTEGER RANGE 34 TO 934;
SIGNAL OB_X2: INTEGER RANGE 464 TO 1904; 
SIGNAL OB_X3: INTEGER RANGE 464 TO 1904;
SIGNAL OB_Y2: INTEGER RANGE 34 TO 934;
SIGNAL OB_Y3: INTEGER RANGE 34 TO 934;
signal random1: integer range 0 to 26448444:= 0;
signal random2: integer range 0 to 15623:= 0;
signal random3: integer range 0 to 16232:= 0;
signal randomx: integer range 0 to 1440:= 0;
signal randomy: integer range 0 to 700:= 0;
constant ballMaxSpeed : integer := 8;
signal LED_BCD: STD_LOGIC_VECTOR (2 downto 0);
signal refresh_counter: STD_LOGIC_VECTOR (20 downto 0);
signal LED_activating_counter: std_logic_vector(1 downto 0);

BEGIN
process(LED_BCD)
begin
    case LED_BCD is
    when "000" => LED_out <= "0000001"; -- "0"     
    when "001" => LED_out <= "1001111"; -- "1" 
    when "010" => LED_out <= "0010010"; -- "2" 
    when "011" => LED_out <= "0000110"; -- "3" 
    when "100" => LED_out <= "1001100"; -- "4" 
    when "101" => LED_out <= "0100100"; -- "5" 
    when "110" => LED_out <= "0100000"; -- "6" 
    when "111" => LED_out <= "0001111"; -- "7" 
    when others => LED_out <= "-------";
    end case;
end process;

process(CLK)
begin 
    if(rising_edge(CLK)) then
        refresh_counter <= refresh_counter + 1;
    end if;
end process;
LED_activating_counter <= refresh_counter(20 downto 19);

process(LED_activating_counter)
begin
    case LED_activating_counter is
    when "00" =>
        Anode_Activate <= "0111"; 
        LED_BCD <= std_logic_vector(to_unsigned(topLifes, 3));
    when "01" =>
        Anode_Activate <= "1111"; 
    when "10" =>
        Anode_Activate <= "1111";
    when "11" =>
        Anode_Activate <= "1110";  
        LED_BCD <= std_logic_vector(to_unsigned(bottomLifes, 3));
    end case;
end process;

CIRCLE(HPOS,VPOS,BALL_X,BALL_Y,RGB,DRAW3);
SQ(HPOS,VPOS,SQ_X1,SQ_Y1,RGB,DRAW1);
SQ(HPOS,VPOS,SQ_X2,SQ_Y2,RGB,DRAW2);

PROCESS(CLK)
BEGIN
IF(CLK'EVENT AND CLK='1')THEN
    IF(DRAW1='1')THEN
	   R<=(others=>'1');
	   G<=(others=>'0');
	   B<=(others=>'1');
	END IF;
	
	IF(DRAW2='1')THEN
	   R<=(others=>'1');
	   G<=(others=>'0');
	   B<=(others=>'1');
	END IF;
	
    IF (DRAW3='1') THEN
        R<=(others=>'0');
        G<=(others=>'0');
        B<=(others=>'0');
    END IF;
      
    IF(DRAW4='1')THEN
        R<=(others=>'1');
        G<=(others=>'1');
        B<=(others=>'0');
    END IF;
    
    IF(DRAW5='1')THEN
        R<=(others=>'1');
        G<=(others=>'1');
        B<=(others=>'0');
    END IF;
    
    IF(DRAW6='1')THEN
        R<=(others=>'1');
        G<=(others=>'1');
        B<=(others=>'0');
    END IF;
       
	IF (DRAW1='0' AND DRAW2='0' AND DRAW3='0' AND DRAW4='0' AND DRAW5='0' AND DRAW6='0')THEN
		R<=(others=>'0');
	    G<=(others=>'1');
	    B<=(others=>'1');
	END IF;
	IF(HPOS<1904)THEN
		HPOS<=HPOS+1;
	ELSE
		HPOS<=0;
		IF(VPOS<932)THEN
		  VPOS<=VPOS+1;
		ELSE
		  VPOS<=0; 
		  IF(KEYS(2)='1')THEN
		      IF( SQ_X1 + 200 < 1904) THEN
			     SQ_X1<=SQ_X1+10;
			  END IF;
		  END IF;
          IF(KEYS(3)='1')THEN
              IF(SQ_X1 > 464) THEN
				  SQ_X1<=SQ_X1-10;
			  END IF;
		  END IF;
						  
		  IF(KEYS(0)='1')THEN
			  IF (SQ_X2 + 200 < 1904) THEN
				   SQ_X2<=SQ_X2+10;
			  END IF;
		  END IF;
		  IF ( SQ_X2 > 464) THEN
               IF(KEYS(1)='1')THEN
				   SQ_X2<=SQ_X2-10;
			   END IF;
		  END IF;
        END IF;
    END IF;
    IF((HPOS>0 AND HPOS<464) OR (VPOS>0 AND VPOS<32))THEN
	   R<=(others=>'0');
	   G<=(others=>'0');
	   B<=(others=>'0');
	END IF;
    IF(HPOS>80 AND HPOS<232)THEN----HSYNC
	   HSYNC<='0';
	ELSE
	   HSYNC<='1';
	END IF;
    IF(VPOS>0 AND VPOS<4)THEN----------vsync
	   VSYNC<='0';
	ELSE
	   VSYNC<='1';
	END IF;
 END IF;
 END PROCESS;
 
process(CLK)
     begin
         if(rising_edge(CLK)) then
             if(count = 1000000) then
                  temp <= not temp;
                  count <= 0;
              else
                  count <= count + 1;
              end if;
          end if;
end process;
CLK_MOVE <= temp;
   
PROCESS(CLK_MOVE, counter, topLifes, bottomLifes)
BEGIN
   
    if topLifes = 0 or bottomLifes = 0 then
        gameOver <= '1';
        BALL_X <= 1184;
        BALL_Y <= 494;
        ballSpeedX <= 8;
        ballSpeedY <= 9;
        topLifes <= 7;
        bottomLifes <= 7;
        counter <= 0;
    end if;
    IF (gameOver = '1') THEN
        BALL_X <= 1184;
        BALL_Y <= 494;
        ballSpeedX <= 0;
        ballSpeedY <= 0;
        counter <= 0;
    ELSIF(RISING_EDGE(CLK_MOVE)) then
        counter <= counter + 1;
        IF (S='1') THEN
            BALL_X <= 1184;
            BALL_Y <= 494;
            ballSpeedX <= 8;
            ballSpeedY <= 9;
            topLifes <= 7;
            bottomLifes <= 7;
            counter <= 0;
        ELSE
        IF (resetBall = '1' ) THEN
            BALL_X <= 1184;
            BALL_Y <= 494;
            resetBall <= '0';
        ELSE
        IF (BALL_X + 10 > SQ_X1 AND BALL_X - 10 < SQ_X1 + 200 AND BALL_Y - 10 < SQ_Y1 + 20 AND BALL_Y > SQ_Y1) THEN
            BALL_Y <= SQ_Y1 + 31;
            ballSpeedY <= -ballSpeedY;
        ELSIF (BALL_X + 10 > SQ_X2 AND BALL_X - 10 < SQ_X2 + 200 AND BALL_Y + 10 > SQ_Y2 AND BALL_Y < SQ_Y2 + 20) THEN
            BALL_Y <= SQ_Y2 - 11;
            ballSpeedY <= -ballSpeedY;
        ELSIF (BALL_Y > 924) THEN
            bottomLifes <= bottomLifes - 1;
            resetBall <= '1';
        ELSIF (BALL_Y < 44) THEN
            topLifes <= topLifes - 1;
            resetBall <= '1';
        ELSE
        BALL_Y <= BALL_Y + ballSpeedY;
        END IF;
    END IF;
    IF ( BALL_X > 1894 ) THEN
        BALL_X <= 1894;
        ballSpeedX <= -ballSpeedX;
        ELSIF ( BALL_X < 474) THEN
            BALL_X <= 474;
            ballSpeedX <= -ballSpeedX;
        ELSE
            BALL_X <= BALL_X + ballSpeedX;
    END IF;
    IF ( counter >= 1000) then
        IF (BALL_X + 10 > OB_X1 AND BALL_X - 10 < OB_X1 + 200 AND BALL_Y - 10 < OB_Y1 + 20 AND BALL_Y > OB_Y1) THEN
            BALL_Y <= OB_Y1 + 31;
            ballSpeedY <= -ballSpeedY;
        ELSIF (BALL_X + 10 > OB_X1 AND BALL_X - 10 < OB_X1 + 200 AND BALL_Y + 10 > OB_Y1 AND BALL_Y < OB_Y1 + 20) THEN
            BALL_Y <= OB_Y1 - 11;
            ballSpeedY <= -ballSpeedY;
        END IF;
    end if;
    IF ( counter >= 2000) then
        IF (BALL_X + 10 > OB_X2 AND BALL_X - 10 < OB_X2 + 200 AND BALL_Y - 10 < OB_Y2 + 20 AND BALL_Y > OB_Y2) THEN
            BALL_Y <= OB_Y2 + 31;
            ballSpeedY <= -ballSpeedY;
        ELSIF (BALL_X + 10 > OB_X2 AND BALL_X - 10 < OB_X2 + 200 AND BALL_Y + 10 > OB_Y2 AND BALL_Y < OB_Y2 + 20) THEN
            BALL_Y <= OB_Y2 - 11;
            ballSpeedY <= - ballSpeedY;
        END IF;
    end if;
    IF ( counter >= 3000) then
        IF (BALL_X + 10 > OB_X3 AND BALL_X - 10 < OB_X3 + 200 AND BALL_Y - 10 < OB_Y3 + 20 AND BALL_Y > OB_Y3) THEN
            BALL_Y <= OB_Y3 + 31;
            ballSpeedY <= -ballSpeedY;
        ELSIF (BALL_X + 10 > OB_X3 AND BALL_X - 10 < OB_X3 + 200 AND BALL_Y + 10 > OB_Y3 AND BALL_Y < OB_Y3 + 20) THEN
            BALL_Y <= OB_Y3 - 11;
            ballSpeedY <= - ballSpeedY;
        END IF;
    end if;
        
    END IF; 
   END IF;   
 END PROCESS;
 
 process(CLK) begin
 if (rising_edge(CLK)) then
    if (random1 = 26448444) then
        random1 <= 0;
    else
        random1 <= random1 + 1;
    end if;
    if (random2 = 15623) then
        random2 <= 0;
    else
        random2 <= random2 + 1;
    end if;
    if (random3 = 16232) then
        random3 <= 0;
    else
        random3 <= random3 + 1;
    end if;
 end if;
 end process;
 
 process(counter, random1, random2, random3) begin
        IF ( counter = 1000) then
            randomx <= (random1) mod 1240;
            randomy <= (random1) mod 660;
            OB_X1 <= randomx + 464;
            OB_Y1 <= randomy + 158;
        end if;
        IF ( counter >= 1000 ) then
            SQ(HPOS,VPOS,OB_X1,OB_Y1,RGB,DRAW4);
        end if;
        IF ( counter = 2000) then
            randomx <= (random2) mod 1240;
            randomy <= (random2) mod 660;
            OB_X2 <= randomx + 464;
            OB_Y2 <= randomy + 158;
        end if;
        IF ( counter >= 2000 ) then
            SQ(HPOS,VPOS,OB_X2,OB_Y2,RGB,DRAW5);
        end if;
        IF ( counter = 3000) then
            randomx <= (random3) mod 1240;
            randomy <= (random3) mod 660;
            OB_X3 <= randomx + 464;
            OB_Y3 <= randomy + 158;
        end if;
        IF ( counter >= 3000 ) then
            SQ(HPOS,VPOS,OB_X3,OB_Y3,RGB,DRAW6);
        end if;
    end process;
 END MAIN;