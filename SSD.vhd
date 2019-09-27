--Started:  9/3/2019
--Finished: 9/5/2019
--Status:   Completed
--7 segment display programed to display kypd keys with FIFO
--FIFO controlled with Button press
--KYPD Supports All Buttons
--FIFO only programmed to support seperate numbers of binary length 8 (7 downto 0)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
 generic (
             width : natural   := 8;
             depth : integer   := 4
   );
    Port (
            clkMain, rstMain :in STD_LOGIC;
            rowIn   :in STD_LOGIC_VECTOR(3 DOWNTO 0);
            colOut  :out STD_LOGIC_VECTOR(3 DOWNTO 0);
            keyEn   :in STD_LOGIC;
            jd      :out STD_LOGIC_VECTOR(7 DOWNTO 0):=(others => '0'); 
            led     :out STD_LOGIC_VECTOR(3 DOWNTO 0);
            
            --Write Interface
                        wrEn                : in STD_LOGIC;
                        --wrData              : in STD_LOGIC_VECTOR(width-1 DOWNTO 0);
                        wrFull              : out STD_LOGIC;
                        
                        --Read Interface    
                        rdEn                : in STD_LOGIC;
                       -- rdData              : out STD_LOGIC_VECTOR(width-1 DOWNTO 0)
                        rdEmpty             : out STD_LOGIC
         );
end SSD;

architecture Behavioral of SSD is
type FIFO_DATA is array ( 0 to depth-1) of STD_LOGIC_VECTOR(width-1 DOWNTO 0);
signal rfData   : FIFO_DATA   := (others =>(others => '0'));
signal kypdData : FIFO_DATA   := (others =>(others => '0'));    --Testing this reg

signal wrIndex, rdIndex     : integer range 0 to 4 := 0;

signal fCount               : integer range 0 to 4 :=0;
signal full, empty          : STD_LOGIC;
signal clkDiv   :STD_LOGIC_VECTOR(24 DOWNTO 0):=(others=> '0');
signal clkSec   :STD_LOGIC_VECTOR(9 DOWNTO 0):=(others=> '0');
signal wrData   :STD_LOGIC_VECTOR(7 DOWNTO 0);

begin

clkSloProc:Process(clkMain)
begin
if (rising_edge (clkMain)) then
    clkDiv <= clkDiv + 1;
end if;
end process;

CtrlProc: process(clkDiv(24), rstMain, kypdData)
begin

        if (rstMain = '1') then
            fCount      <= 0;
            wrIndex     <= 0;
            rdIndex     <= 0;
            
              
         elsif (rising_edge(clkDiv(24))) then
         
        --Total Number of Words in FIFO;
                if (wrEn = '1' and rdEn = '0') then
                    fCount  <= fCount + 1;
                elsif (wrEn = '0' and rdEn = '1') then
                    fCount  <= fCount - 1;
                end if;
            
        --Track write index and control roll over       
                if (wrEn = '1' and full = '0') then
                    if wrIndex = depth - 1 then
                        wrIndex <= 0;
                    else
                        wrIndex <= wrIndex + 1;
                    end if;                      
                end if;
            
        -- Tracks Read index and cpontrols roll over
                if (rdEn = '1' and empty = '0') then
                    if rdIndex = depth -1 then
                        rdIndex <= 0;
                    else
                        rdIndex <= rdIndex + 1;
                    end if;
                end if;
            
        --Registers input Data for writes
                if (wrEn = '1') then
                    rfData(wrIndex) <= wrData;
                end if;
end if;
end process;
--rdData  <= rfData(rdIndex);
full    <= '1' when fCount= depth  else '0';    --red when full
empty   <= '1' when fCount= 0       else '0';   --blue when empty

wrFull  <= full;    --red when full
rdEmpty <= empty;   --blue when empty
jd <= rfData(rdIndex);

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

