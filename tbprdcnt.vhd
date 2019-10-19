

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.ALL;

entity tbprdcnt is
--  Port ( );
end tbprdcnt;

architecture Behavioral of tbprdcnt is
component prdcnt
    
    Port (
        clkMain, rstMain, start, si : in STD_LOGIC;
        ready, readycount, doneTick             : out STD_LOGIC;
        prd                         : out STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
end component;  

CONSTANT clkMsCount         : integer := 5;
Signal tb_start                             : STD_LOGIC :='1';
Signal tb_rstMain                           : STD_LOGIC :='1';
Signal tb_clkMain                           : STD_LOGIC :='0';      
signal tb_si                                : STD_LOGIC :='1';
signal tb_ready, tb_readycount, tb_doneTick                : STD_LOGIC;
signal tb_prd                               : STD_LOGIC_VECTOR(9 DOWNTO 0);
      
begin
uut: prdcnt Port Map(
    start       => tb_start,
    rstMain     => tb_rstMain,
    clkMain     => tb_clkMain,
    si         => tb_si,
    ready       => tb_ready,
    readycount  => tb_readycount,
    doneTick    => tb_doneTick,
    prd        => tb_prd);
    
CLOCK:process
begin
    tb_clkMain <= '0';
    --tb_si   <= '1';
    wait for 10 NS;
    tb_clkMain <= '1';
    --tb_si   <= '0';
    wait for 10 NS;
end process;

SICLK:process
begin
    tb_si <= '1';
    
    wait for 5 NS;
    
    tb_si   <= '0';
    wait for 50 NS;
end process;
        
STIM_PROC: process
begin
    tb_start <= '0';
    tb_rstMain <= '0';
    wait for 10 ns;
    tb_start <= '1';
    
    --wait for 10 ns;
    --tb_si   <= '1';
    wait for 500 ns;
end process;      
    
end Behavioral;
