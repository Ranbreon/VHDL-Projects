

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_lfc is
--  Port ( );
end tb_lfc;

architecture Behavioral of tb_lfc is
component lowfreqcounterTL
    Port (
            clkMain, rstMain, start, si : in STD_LOGIC;
            bcd0, bcd1, bcd2, bcd3      : out STD_LOGIC_VECTOR(3 DOWNTO 0)
            );   
end component;  

Signal tb_start                             : STD_LOGIC :='1';
Signal tb_rstMain                           : STD_LOGIC :='1';
Signal tb_clkMain                           : STD_LOGIC :='0';    
signal tb_si                                : STD_LOGIC :='0';
signal tb_bcd0, tb_bcd1, tb_bcd2, tb_bcd3   : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
uut: lowfreqcounterTL Port Map(
    start       => tb_start,
    rstMain     => tb_rstMain,
    clkMain     => tb_clkMain,
    si          => tb_si,
    bcd3        => tb_bcd3,
    bcd2        => tb_bcd2,
    bcd1        => tb_bcd1,
    bcd0        => tb_bcd0);

CLOCK:process
    begin
        tb_clkMain <= '0';
        wait for 10 NS;
        tb_clkMain <= '1';
        wait for 10 NS;
    end process;

OutSigClk:process
    begin
        tb_si <= '0';
        wait for 7 NS;
        tb_si <= '1';
        wait for 3 NS;
    end process;    
    
STIM_PROC: process
        begin
        tb_start <= '0';
        tb_rstMain <= '1';
        wait for 10 ns;
        tb_start <= '1';
        tb_rstMain <= '0';
        wait for 200 ns;
        end process;          
    
end Behavioral;
