--Period Counter
--Started: August 6, 2019;
--Status: WIP, August 6, 2019
--works with integer of 5 on test Bench but nothing higher

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity prdcnt is
  Port (
        clkMain, rstMain, start, si : in STD_LOGIC;
        ready, readycount, doneTick             : out STD_LOGIC;
        prd                         : out STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
end prdcnt;

architecture rtl of prdcnt is

CONSTANT clkMsCount         : integer := 5;
type StateType is (idle, waite, count, done);
signal stateR, stateNext    : StateType;
signal tR, tNext            : unsigned(16 DOWNTO 0);    --Up to 100000
signal pR, pNext            : unsigned(9 DOWNTO 0);     --Up to 1 Second
signal delayR, edge         : STD_LOGIC;

begin
ClkProc: process (clkMain, rstMain)
begin
    if (rstMain = '1') then
        stateR  <= idle;
        tR      <= (others => '0');
        pR      <= (others => '0');
        delayR  <= '0';
    elsif (rising_edge (clkMain)) then
        stateR  <= stateNext;
        tR      <= tNext;
        pR      <= pNext;
        delayR  <= si;
    end if;
end process;      

--edge detect
 edge <= (not delayR) and si;
 
 NslProc: process (start, edge, StateR, tR, tNext, pR)
 begin
 ready      <= '0';
 readycount      <= '0';
 doneTick   <= '0';
 stateNext  <= stateR;
 tNext         <= tR;
 pNext         <= pR;
 case stateR is
    when idle   =>
        ready   <= '1';
        if (start = '1') then
            stateNext <= waite;
        end if;    
    when waite  =>
        if (edge = '1') then
            stateNext   <= count;
            tNext       <= (others => '0');
            pNext       <= (others => '0');
        end if;
    when count  =>
        if (edge = '1') then
            stateNext <= done;
            readycount <= '1';
        else
            if (tR = clkMsCount - 1) then
                tNext   <= (others => '0');
                pNext   <= pR + 1; 
            else
                tNext <= tR + 1;
            end if;
        end if;
    when done =>
        doneTick    <= '1';
        stateNext   <= idle;
    end case;
end process;

prd <= STD_LOGIC_VECTOR(pR);                                        
end rtl;
