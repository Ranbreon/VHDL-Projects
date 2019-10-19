--Low Frequency Counter (first Top Level design)
--Started: August 7, 2019
--Status: WIP, Runs, Not Correctly but proves how TL works
--Combines Division Circuit, binary to binary converted decimal, period counter

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.ALL;

entity lowfreqcounterTL is 
    Port (
            clkMain, rstMain, start, si : in STD_LOGIC;
            bcd0, bcd1, bcd2, bcd3      : out STD_LOGIC_VECTOR(3 DOWNTO 0)
         );
end lowfreqcounterTL;

architecture Behavioral of lowfreqcounterTL is

type StateType is (idle, count, frq, b2b);
signal stateR, stateNext        : StateType;
signal prd                      : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal dvsr, dvnd, quo          : STD_LOGIC_VECTOR(19 DOWNTO 0);
signal prdStart, prdDoneTick    : STD_LOGIC;
signal divStart, divDoneTick    : STD_LOGIC;
signal b2bStart, b2bDoneTick    : STD_LOGIC;

begin
--Component instantination
--Period Initiate
PrdCounterUnit: entity work.prdcnt
    Port map (
                clkMain     => clkMain,
                rstMain     => rstMain,
                start       => prdStart,
                si          => si,
                ready       => open,
                doneTick    => prdDoneTick,
                prd         => prd
                );

--Division Circuit Initiate
divUnit: entity work.DivCir
    generic map(   width   => 20,
                    Cbit    => 5
                 )                       
    port Map (
                clkMain     => clkMain,
                rstMain     => rstMain,
                start       => divStart, 
                dvsr        => dvsr,
                dvnd        => dvnd,
                quo         => quo,
                doneTick    => divDoneTick,
                ready       => open,
                rmd         => open
                );

--Binary to BCD initiate
b2bUnit: entity work.bin2bcd
    port map(
                clkMain     => clkMain,
                rstMain     => rstMain,
                start       => b2bStart,
                doneTick    => b2bDoneTick,
                bin         => quo (6 DOWNTO 0),
                bcd3        => bcd3,
                bcd2        => bcd2,
                bcd1        => bcd1,
                bcd0        => bcd0
                );
                      
--signal width extension
dvnd    <= STD_LOGIC_VECTOR(to_unsigned(1000000, 20));
dvsr    <= "0000000000" & prd;

--Master FSM Register
MasterProc: process ( clkMain, rstMain)
begin
    if (rstMain = '1') then
        stateR  <= idle;
    elsif (rising_edge (clkMain)) then
        stateR  <= stateNext;
    end if;    
end process;

NextLogicProc: process (stateR, start, prdDoneTick, divDoneTick, b2bDoneTick)
begin
    stateNext   <= stateR;
    prdStart    <= '0';
    divStart    <= '0';
    b2bStart    <= '0';
    case (stateR) is
        when idle => 
            if (start = '1') then
                stateNext   <= count;
                prdStart    <= '1';
            end if;
        when count =>
            if (prdDoneTick = '1') then
                divStart    <= '1';
                stateNext   <= frq; 
            end if;
        when frq => 
            if (divDoneTick = '1') then
                b2bStart    <= '1';
                stateNext   <= b2b;
            end if;
        when b2b =>
            if (b2bDoneTick = '1') then
                stateNext   <= idle;
            end if;
    end case;
end process;
                                                                                        
end Behavioral;
