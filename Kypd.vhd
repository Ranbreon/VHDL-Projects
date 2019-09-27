--KYPD Code only
--Status: Completed, Confirmed works for all rows and columns


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Kypd is
    Port (
             clkMain, rstMain   :in STD_LOGIC;
             keyEn              :in STD_LOGIC;
             rowIn              :in STD_LOGIC_VECTOR(3 DOWNTO 0);
             colOut             :out STD_LOGIC_VECTOR(3 DOWNTO 0);
             wrData             :out STD_LOGIC_VECTOR(7 DOWNTO 0)           
     );
end Kypd;

architecture Behavioral of Kypd is
signal clkSec   :STD_LOGIC_VECTOR(9 DOWNTO 0):=(others=> '0');
--signal wrData   :STD_LOGIC_VECTOR(7 DOWNTO 0);

begin
KypdProc: process(clkMain, clkSec)
begin
colOut  <= "0000";
if (rising_edge(clkMain)) then
--Column 1 
    if clkSec = "000100000" then
        colOut <= "0111";
        clkSec <= clkSec + 1;
    elsif  clkSec = "0001001000" then  
        if rowIn = "0111" then
            if (keyEn = '1') then
                wrData      <= "00000110";  
            end if;                 --row: 1, #1
        elsif rowIn = "1011" then
            if (keyEn = '1') then
                wrData      <= "01100110"; --row: 2, #4
            end if;
        elsif rowIn = "1101" then
            if (keyEn = '1') then
                wrData      <= "00000111"; --row: 3, #7
            end if;            --row: 3, #7
        elsif rowIn = "1110" then
            if (keyEn = '1') then
                wrData      <= "00111111"; --row: 4, #0
            end if;
        end if;
        clkSec <= clkSec + 1; 
--Column 2                  
    elsif clkSec = "0011000000" then
            colOut  <= "1011";
            clkSec <= clkSec + 1;
    elsif  clkSec = "0011001000" then  
        if rowIn = "0111" then
            if (keyEn = '1') then
            wrData      <= "01011011";                --row: 1, #2
            end if;
        elsif rowIn = "1011" then
            if (keyEn = '1') then
            wrData      <= "01101101";                --row: 2, #5
            end if;
        elsif rowIn = "1101" then
            if (keyEn = '1') then
            wrData      <= "01111111";                --row: 3, #8
            end if;
        elsif rowIn = "1110" then
            if (keyEn = '1') then
            wrData      <= "01110001";                --row: 4, #F
            end if;
        end if;              
        clkSec <= clkSec + 1;    
--Column 3        
    elsif clkSec = "0111000000" then   
        colOut  <= "1101";
        clkSec <= clkSec + 1;   
    elsif  clkSec = "0111001000" then  
        if rowIn = "0111" then
            if (keyEn = '1') then
            wrData      <= "01001111";                --row: 1, #3
            end if;
        elsif rowIn = "1011" then
        if (keyEn = '1') then
            wrData      <= "01111101";                --row: 2, #6
            end if;
        elsif rowIn = "1101" then
        if (keyEn = '1') then
            wrData      <= "01101111";                --row: 3, #9
            end if;
        elsif rowIn = "1110" then
        if (keyEn = '1') then
            wrData      <= "01111001";                --row: 4, #E
            end if;
        end if;   
        clkSec <= clkSec + 1;   
--Column 4                  
    elsif clkSec = "1111000000" then   
        colOut  <= "1110";
        clkSec <= clkSec + 1;
    elsif  clkSec = "1111001000" then  
        if rowIn = "0111" then
            if (keyEn = '1') then
            wrData      <= "01110111";               --row: 1, #A
            end if;
        elsif rowIn = "1011" then
            if (keyEn = '1') then
            wrData      <= "01111100";                --row: 2, #B
            end if;
        elsif rowIn = "1101" then
            if (keyEn = '1') then
            wrData      <= "00111001";               --row: 3, #C
            end if;
        elsif rowIn = "1110" then
            if (keyEn = '1') then
            wrData      <= "01011110";                --row: 4, #D
            end if;
        end if;   
        clkSec <= clkSec + 1;   
--end of main if             
    else    
        clkSec <= clkSec + 1;     
    end if;
end if;
end process;  


end Behavioral;
