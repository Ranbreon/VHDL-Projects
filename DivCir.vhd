--Division Circuit
--Started:   July 29,2019
--Finished: August 1,2019
--Status: Working for TestBench

--August Build
--Working for TB using 4 bits.


--Zybo Clock: 33.3MHZ

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.ALL;


entity DivCir is
    Generic (
                width               : integer := 4;
                CBIT                : integer := 2 --CBIT = log2(w)+1
                );
    Port    ( 
                clkMain, rstMain    : in std_logic;
                start               : in std_logic;
                dvsr                : in std_logic_vector(width-1 DOWNTO 0);
                dvnd              : in std_logic_vector(width-1 DOWNTO 0);
                ready               : out std_logic;
                doneTick            : out std_logic;
                quo,rmd            : out std_logic_vector(width-1 DOWNTO 0)     
    );
end DivCir;

architecture rtl of DivCir is
type STATETYPE is (idle, op, last, done);
signal stateR, stateNext    : STATETYPE;
signal rhR, rhNext          : unsigned (width - 1 DOWNTO 0);            --register bit shift left dividend remaing dividend
signal rlR, rlNext          : std_logic_vector(width - 1 DOWNTO 0);     --register bit shift left dividend_quotient
signal rhTmp                : unsigned (width - 1 DOWNTO 0);
signal dR, dNext            : unsigned (width - 1 DOWNTO 0);            --intial divisor
signal nR, nNext            : unsigned (CBIT - 1 DOWNTO 0);             --number of times to keep dividing
signal qBit                 : std_logic;

begin

--Async Reset and Sync Clock
RgstrProc: process(clkMain, rstMain)
begin
    if (rstMain = '1') then
        stateR  <= idle;
        rhR     <= (others => '0');
        rlR     <= (others => '0');
        dR      <= (others => '0');
        nR      <= (others => '0');
    elsif (rising_edge (clkMain)) then
        stateR  <= stateNext;
        rhR     <= rhNext;
        rlR     <= rlNext;
        dR      <= dNext;
        nR      <= nNext;  
    end if;
end process;  

NSLogic: process ( stateR,rhR,rlR, dR, nR, start, dvsr, dvnd, rhTmp,qBit, nNext)
begin
ready       <= '0';
doneTick    <= '0';
stateNext   <= stateR;
rhNext      <= rhR;
rlNext      <= rlR;
dNext       <= dR;
nNext       <= nR;
case stateR is
    when idle => ready <= '1';
        if (start    = '1') then
            rhNext      <= (others => '0');
            rlNext      <= dvnd;
            dNext       <= unsigned (dvsr);
            nNext       <= to_unsigned (width + 1,CBIT);
            stateNext   <= op;
        end if;
    when op => 
        rlNext  <= rlR(width - 2 DOWNTO 0) & qBit;
        rhNext  <= rhTmp(width - 2 DOWNTO 0) & rlR(width - 1);
        nNext   <= nR - 1;
        if (nNext = 1) then
            stateNext <= last;
        end if;
    when last =>
        rlNext      <= rlR(width - 2 DOWNTO 0) & qBit;  
        rhNext      <= rhTmp;
        stateNext   <= done;   
    when done => 
        stateNext   <= idle;
        doneTick    <= '1';
end case;
end process;

--Logic Comparison & Subtraction             
CompSub: process (rhR, dR)
begin
    if (rhR >= dR) then
        rhTmp   <= rhR - dR;
        qBit    <= '1';
    else
        rhTmp <= rhR;
        qbit <= '0';
    end if;
end process;

--OutPuts
quo <= rlR;                    
rmd <= std_logic_vector(rhR);               

end rtl;
