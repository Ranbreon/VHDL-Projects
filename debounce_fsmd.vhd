--Debounced using FSMD Explicit Design
--Started on July 23,2019
--Finished on July 24,2019
--Status: Working on Zybo Z7
--Adapted for use on Zybo Z7-10
--LED and button 0 for  swG15 for verification purposes.

--Additional Code Added On: July 26, 2019
--Status: Complete and Working 
--2 LEDS debounced using 1 pushbutton

--Zybo Clock: 33.3MHZ
--New Clock for qNext: 33.3MHz/25 = 1.32MHz

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.ALL;

entity debounce_fsmd is

  Port ( 
        clkMain,rstMain :in STD_LOGIC;
        swG15           :in STD_LOGIC;
        dbLevel         :out STD_LOGIC_VECTOR(1 DOWNTO 0);
        dbTick          :out STD_LOGIC
        );
end debounce_fsmd;

architecture rtl of debounce_fsmd is
    --CONSTANT N: integer     := 5;
    type STATE_TYPE is (zero,wait1,one,wait0,two,wait2,three,wait3,endHold,wait4);
    signal stateR,stateNext : STATE_TYPE;
    signal qReg,qNext       : STD_LOGIC_VECTOR(25 DOWNTO 0); --untested with vector of 25 but works with 10
    signal qLoad,qDec,qZero : STD_LOGIC;

begin
--FSMD State and Data Registers
RgstrProc: process(clkMain, rstMain)
begin
    if (rstMain = '1') then
        stateR  <= zero;
        qReg    <= (others => '0');
    elsif (rising_edge (clkMain)) then
        stateR  <= stateNext;
        qReg    <= qNext;
    end if;
end process;  
 
 qNext  <=  (others => '1') when qLoad = '1' else
             qReg - 1 when qDec = '1' else
             qReg;
 qZero  <=  '1' when qNext = 0 else '0';                   
        
--FSMD Control Path
CntrlProc: process (stateR,swG15,qZero)
begin
    qDec        <= '0';
    dbTick      <= '0';
    qLoad       <= '0';
    stateNext   <= stateR;
    Case stateR is
        when zero=> dbLevel <= "00";
            if (swG15 = '1') then
                stateNext <= wait1;
                qLoad   <= '1';
            end if;
        when wait1=> dbLevel <= "00";
            if (swG15 = '1') then
                qDec        <= '1';
                if (qZero <= '1') then
                    stateNext   <= one;
                    dbTick      <= '1';
                end if;
            else
                stateNext   <=  zero;
            end if;    
        when one=> dbLevel <= "01";
            if (swG15 = '0') then
                stateNext   <= wait0;
                qLoad       <= '1';
            end if;   
        when wait0=> dbLevel <= "01";
            if (swG15 = '0') then
                qDec        <= '1';   
                if (qZero = '1') then
                    stateNext   <= two; --Change to zero for single LED
                end if;
            else
                stateNext   <= one;
            end if;  
            
 --Start of New Code    
 --Works, debounces two LEDs using 1 pushbutton  
        when two=> dbLevel <= "01";
            if (swG15 = '1') then
                stateNext   <= wait2;
                qLoad       <= '1';
            end if;
        when wait2=> dbLevel <= "01";
            if (swG15 = '1') then
                 qDec        <= '1';
                 if (qZero <= '1') then
                    stateNext   <= three;
                    dbTick      <= '1';
                 end if;
            else
                stateNext   <=  two;
            end if;    
        when three=> dbLevel <= "11";
            if (swG15 = '0') then
                stateNext   <= wait3;
                qLoad       <= '1';
            end if;
        when wait3=> dbLevel <= "11";
            if (swG15 = '0') then
                qDec        <= '1';   
                if (qZero = '1') then
                    stateNext   <= endHold;
                end if;
             else
                stateNext   <= three;
            end if; 
            
--Buffer
--Prevents "11" going to "00" as soon as pushbutton is released
            when endHold=> dbLevel <= "11";
                 if (swG15 = '1') then
                    stateNext   <= wait4;
                    qLoad       <= '1';
                end if;
            when wait4=> dbLevel <= "11";
                if (swG15 = '1') then
                    qDec        <= '1';   
                    if (qZero = '1') then
                        stateNext   <= wait4;
                    end if;
                else
                    stateNext   <= zero;
                end if;          
    end case;
end process;                 
end rtl;
