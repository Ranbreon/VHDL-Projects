---Not Currently working, debating on using FSM for count up and down

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;--can't leave this in, its bad coding. need to replace for clkdiv later

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LEDkitt is
  Port ( 
        clkMain, rstMain : in std_logic;
        LED     : out std_logic_vector(3 DOWNTO 0));
end LEDkitt;

architecture Behavioral of LEDkitt is
type STATETYPE is (idle, count, swcount);
signal stateR, stateN   : STATETYPE;
signal clkDiv:  std_logic_vector(1 Downto 0):=(others=> '0');
signal lcnt: integer :=0;

begin

clkSloProc:Process(clkMain)
begin
if (rising_edge (clkMain)) then
    clkDiv <= clkDiv + 1;
end if;
end process;

--Master FSM Register
MasterProc: process ( clkDiv(1), rstMain)
begin
    if (rstMain = '1') then
        stateR  <= idle;
    elsif (rising_edge (clkDiv(1))) then
        stateR  <= stateN;
    end if;    
end process;

NextStateLogic: process ( clkDiv(1))
begin
 stateN <= stateR;
    Case stateR is
        when idle =>
            LED     <= "0000";
            lcnt    <= 0;
            stateN <= count;
        when count =>
            if (rising_edge(clkDiv(1))) then
                if (lcnt <= 5) then
                    lcnt <= lcnt + 1;
                    stateN  <= count;
                else
                    stateN  <= swcount;
                end if;
            end if; 
        when swcount =>
            if (rising_edge(clkDiv(1))) then
               if (lcnt > 1) then
                    lcnt <= lcnt - 1;
                    stateN <= swcount;
               else
                    stateN <= count;
               end if;
            end if; 
        end case;     
end process;

--LEDLightProc: process(clkDiv(1))
--begin
--    LED <= "0000";
--    if (rising_edge(clkDiv(1))) then
--    if (lcnt = 0) then
--            LED <= "0001";
--            --lcnt <= lcnt + 1;
--        elsif (lcnt = 1) then
--            LED <= "0001";
--            --lcnt <= lcnt + 1;
--        elsif (lcnt = 2) then
--            LED <= "0011";  
--            --lcnt <= lcnt + 1;
--        elsif (lcnt = 3) then
--            LED <= "0110";
--            --lcnt <= lcnt + 1;
--        elsif (lcnt = 4) then
--            LED <= "1100"; 
--            --lcnt <= lcnt + 1;
--        elsif (lcnt = 5) then
--            LED <= "1000";
--            --lcnt <= lcnt + 1;         
--        elsif (lcnt = 6) then
--            LED <= "1000"; 
--            --lcnt <= lcnt + 1;
--        end if; 
--        end if;
--end process;            
end Behavioral;
