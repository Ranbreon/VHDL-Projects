--Binary to BCD (binary converted decimal)
--Started: August 5, 2019;
--Status: Completed August 6, 2019;
--Works with included TestBench
--Adjust tb_bin for vectors in testbench file
--Adjust nNext for number of vectors in main file


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bin2bcd is
  Port (
        clkMain, rstMain, start : in std_logic;
        bin                     : in std_logic_vector(6 downto 0);
        ready, doneTick         : out std_logic;
        bcd3, bcd2, bcd1, bcd0  : out std_logic_vector(3 downto 0)  
   );
end bin2bcd;

architecture rtl of bin2bcd is
type StateType is (idle, op, done);
signal stateR, stateNext                        : StateType;
signal p2sR, p2sNext                            : std_logic_vector(6 downto 0);
signal nR, nNext                                : unsigned (3 downto 0);
signal bcd3R, bcd3Next                          : unsigned (3 downto 0);
signal bcd2R, bcd2Next                          : unsigned (3 downto 0);
signal bcd1R, bcd1Next                          : unsigned (3 downto 0);
signal bcd0R, bcd0Next                          : unsigned (3 downto 0);
signal bcd3Tmp, bcd2Tmp, bcd1Tmp, bcd0Tmp       : unsigned (3 downto 0);

begin

ClkProc: process (clkMain, rstMain)
begin
    if (rstMain = '1') then
        stateR  <= idle;
        p2sR    <= (others => '0');
        nR      <= (others => '0');
        bcd3R   <= (others => '0');
        bcd2R   <= (others => '0');
        bcd1R   <= (others => '0');
        bcd0R   <= (others => '0');
    elsif (rising_edge (clkMain)) then
        stateR  <= stateNext;
        p2sR    <= p2sNext;
        nR      <= nNext;
        bcd3R   <= bcd3Next;
        bcd2R   <= bcd2Next;
        bcd1R   <= bcd1Next;
        bcd0R   <= bcd0Next;
    end if;
end process;       
        
NSLProc: process (stateR, start, p2sR, nR, nNext, bin, bcd0R, bcd1R, bcd2R, bcd3R, bcd0Tmp, bcd1Tmp, bcd2Tmp, bcd3Tmp)
begin
    stateNext   <= stateR;
    p2sNext     <= p2sR;
    nNext       <= nR;
    bcd3Next    <= bcd3R;
    bcd2Next    <= bcd2R;
    bcd1Next    <= bcd1R;
    bcd0Next    <= bcd0R;
    ready       <= '0';
    doneTick    <= '0';
    case stateR is
        when idle   => 
            ready   <= '1';
            if (start = '1') then
                stateNext   <= op;
                bcd3Next    <= (others => '0');
                bcd2Next    <= (others => '0');
                bcd1Next    <= (others => '0');
                bcd0Next    <= (others => '0');
                nNext       <= "0111";
                p2sNext     <= bin;
            end if;
        when op     =>    
            p2sNext     <= p2sR (5 downto 0) & '0';    --shift MSB of Bin input off and onto BCD0
            
            bcd0Next    <= bcd0Tmp (2 downto 0) & p2sR(6);
            bcd1Next    <= bcd1Tmp (2 downto 0) & bcd0Tmp(3);
            bcd2Next    <= bcd2Tmp (2 downto 0) & bcd1Tmp(3);
            bcd3Next    <= bcd3Tmp (2 downto 0) & bcd2Tmp(3);
            nNext       <= nR-1;
            if (nNext = 0) then
                stateNext   <= done;
            end if;
        when done   =>      
            stateNext   <= done;
            doneTick    <= '1';
    end case;
end process;                              

bcd0Tmp <= bcd0R + 3 when bcd0R > 4 else bcd0R;
bcd1Tmp <= bcd1R + 3 when bcd1R > 4 else bcd1R;
bcd2Tmp <= bcd2R + 3 when bcd2R > 4 else bcd2R;    
bcd3Tmp <= bcd3R + 3 when bcd3R > 4 else bcd3R;    

bcd0    <= std_logic_vector(bcd0R);  
bcd1    <= std_logic_vector(bcd1R); 
bcd2    <= std_logic_vector(bcd2R); 
bcd3    <= std_logic_vector(bcd3R); 
end rtl;
