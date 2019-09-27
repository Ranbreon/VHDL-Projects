----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/14/2019 10:48:12 AM
-- Design Name: 
-- Module Name: kypdregister - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity kypdregister is
    Port ( 
            clkMain                                : in STD_LOGIC;
            wrEn, rdataIn                             : in STD_LOGIC;
            rowBtn                                  : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            colBtn                                  : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            LED                                     : out STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
end kypdregister;

architecture Behavioral of kypdregister is
--type mem2dType is array (0 to 0) of 
 --   STD_LOGIC_VECTOR(7 DOWNTO 0);
signal arrayKey : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal clkSec   : STD_LOGIC_VECTOR(9 DOWNTO 0);
--signal rcData   : STD_LOGIC_VECTOR(3 DOWNTO 0);     
signal rcWrite  : STD_LOGIC_VECTOR(3 DOWNTO 0); --Combining row and column to save to 1 register

begin


--PadRegProc: process (clkMain, wrEn) 
--begin
--    if (rising_edge (clkMain)) then
--        if (wrEn = '1') then
--            arrayKey <= rcWrite;
--        end if;
--    end if;
--end process;        

DecodeProc: process (rdataIn, arrayKey)
begin
    if (rdataIn = '1') then
        if arrayKey = "0001" then
            LED <=   "0001";
        elsif arrayKey = "0100" then
          LED <=   "0100";    
        end if;
    end if;
end process;

readKeyProc: process(clkMain, wrEn)
begin
colBtn <= "0000";
if (rising_edge (clkMain)) then
    
    if clkSec = "0001000000" then
        colBtn  <= "0111";              --Column 1: 1,4,7,0
        clkSec  <= clkSec + 1;
    elsif  clkSec = "0001001000" then  
        if rowBtn = "0111" then
            if (wrEn = '1') then
                    rcWrite     <= "0001";  
                    arrayKey <= rcWrite;
                       end if;                 --row: 1, #1
        elsif rowBtn = "1011" then
            if (wrEn = '1') then
                    rcWrite <= "0100"; --row: 2, #4
                    arrayKey <= rcWrite;
                    end if;
        elsif rowBtn = "1101" then
          -- LED <= "0111";              --row: 3, #7
        elsif rowBtn = "1110" then
           -- LED <= "0000";              --row: 4, #0
        end if;
        clkSec <= clkSec + 1;  
    elsif clkSec = "0011000000" then
        colBtn  <= "1011";
        clkSec <= clkSec + 1;
    elsif  clkSec = "0011001000" then  
        if rowBtn = "0111" then
           -- LED <= "0010";              --row: 1, #2
        elsif rowBtn = "1011" then
           -- LED <= "0101";              --row: 2, #5
        elsif rowBtn = "1101" then
           -- LED <= "1000";              --row: 3, #8
        elsif rowBtn = "1110" then
           -- LED <= "1111";              --row: 4, #F
        end if;              
        clkSec <= clkSec + 1;    
     elsif clkSec = "0111000000" then   
            colBtn  <= "1101";
            clkSec <= clkSec + 1;   
     elsif  clkSec = "0111001000" then  
        if rowBtn = "0111" then
            --LED <= "0011";              --row: 1, #3
         elsif rowBtn = "1011" then
          -- LED <= "0110";              --row: 2, #6
         elsif rowBtn = "1101" then
          --  LED <= "1001";              --row: 3, #9
         elsif rowBtn = "1110" then
            --LED <= "1110";              --row: 4, #E
         end if;   
         clkSec <= clkSec + 1;             
     elsif clkSec = "1111000000" then   
            colBtn  <= "1110";
            clkSec <= clkSec + 1;
     elsif  clkSec = "1111001000" then  
         if rowBtn = "0111" then
            --LED <= "1010";              --row: 1, #A
         elsif rowBtn = "1011" then
            --LED <= "1011";              --row: 2, #B
         elsif rowBtn = "1101" then
           -- LED <= "1100";              --row: 3, #C
         elsif rowBtn = "1110" then
           -- LED <= "1101";              --row: 4, #D
         end if;   
            clkSec <= clkSec + 1;        
     else
         clkSec  <= clkSec + 1;
    end if;
end if;            
end process;

end Behavioral;
