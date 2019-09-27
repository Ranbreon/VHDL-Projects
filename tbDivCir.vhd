library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.ALL;

entity tbDivCir is
--  Port ( );
end tbDivCir;

architecture Behavioral of tbDivCir is
component DivCir
    Generic (
                width               : integer := 4;
                CBIT                : integer := 2 --CBIT = log2(w)+1
            );
    Port (
                clkMain, rstMain: in std_logic;
                start           : in std_logic;
                dvsr            : in std_logic_vector(width-1 DOWNTO 0) ;
                dvnd            : in std_logic_vector(width-1 DOWNTO 0);
                ready           : out std_logic;
                doneTick        : out std_logic;
                quo,rmd         : out std_logic_vector(width-1 DOWNTO 0)   
        );
end component;

Signal tb_start : STD_LOGIC :='1';
Signal tb_rstMain : STD_LOGIC :='1';
Signal tb_clkMain : STD_LOGIC :='0';
Signal tb_dvsr : std_logic_vector(4-1 DOWNTO 0) := "0001";
Signal tb_dvnd : std_logic_vector(4-1 DOWNTO 0) := "1111";
Signal tb_ready : STD_LOGIC;
Signal tb_doneTick : STD_LOGIC;
Signal tb_quo : STD_LOGIC_VECTOR(4-1 DOWNTO 0);
Signal tb_rmd : STD_LOGIC_VECTOR(4-1 DOWNTO 0);


begin
uut: DivCir Port Map(
    start => tb_start,
    rstMain => tb_rstMain,
    clkMain => tb_clkMain,
    dvsr => tb_dvsr,
    dvnd => tb_dvnd,
    doneTick => tb_doneTick,
    quo => tb_quo,
    rmd => tb_rmd);

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
