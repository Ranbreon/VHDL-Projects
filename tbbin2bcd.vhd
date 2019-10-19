----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/06/2019 10:58:31 AM
-- Design Name: 
-- Module Name: tbbin2bcd - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.ALL;

entity tbbin2bcd is
--  Port ( );
end tbbin2bcd;

architecture Behavioral of tbbin2bcd is
component bin2bcd
    Port (
            clkMain, rstMain, start : in std_logic;
            bin                     : in std_logic_vector(6 downto 0);
            ready, doneTick         : out std_logic;
            bcd3, bcd2, bcd1, bcd0  : out std_logic_vector(3 downto 0)
            );   
end component;      

Signal tb_start                             : STD_LOGIC :='1';
Signal tb_rstMain                           : STD_LOGIC :='1';
Signal tb_clkMain                           : STD_LOGIC :='0';      
signal tb_bin                               : STD_LOGIC_VECTOR(6 DOWNTO 0):= "1111111";
signal tb_ready                             : STD_LOGIC;
signal tb_doneTick                          : STD_LOGIC;
signal tb_bcd3, tb_bcd2, tb_bcd1, tb_bcd0   : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
uut: bin2bcd Port Map(
    start       => tb_start,
    rstMain     => tb_rstMain,
    clkMain     => tb_clkMain,
    bin         => tb_bin,
    ready       => tb_ready,
    doneTick    => tb_doneTick,
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
    
  STIM_PROC: process
    begin
    tb_start <= '0';
    tb_rstMain <= '1';
    wait for 10 ns;
    tb_start <= '1';
    tb_rstMain <= '0';
    wait for 200 ns;
    --tb_BTN1 <= '0';
    --tb_CLR <= '1';
    --wait for 10 ns;
    end process;      

end Behavioral;
