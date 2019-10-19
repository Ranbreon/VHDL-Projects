--TestBench for Debounce FSMD Circuit
--Not Confirmed Working

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tbdebouncefsmd is
--  Port ( );
end tbdebouncefsmd;

architecture rtl of tbdebouncefsmd is
    component debounce_fsm
    
        Port(
                clkMain, rstMain    : in STD_LOGIC;
                swG15               : in STD_LOGIC;
                dbLevel,dbTick      : out STD_LOGIC;
                LED1                : out std_logic
                );
end component;

CONSTANT N: integer := 22;
Signal tb_swG15     : STD_LOGIC     :='0';
Signal tb_rstMain   : STD_LOGIC     :='0';
Signal tb_clkMain   : STD_LOGIC     :='0';
signal tb_dbLevel   : STD_LOGIC;
signal tb_dbTick    : STD_LOGIC;
Signal tb_LED1      : STD_LOGIC;

begin
uut: debounce_fsm PORT MAP(
swG15       => tb_swG15,
rstMain     => tb_rstMain,
clkMain     => tb_clkMain,
dbLevel     => tb_dbLevel,
dbTick      => tb_dbTick,
LED1        => tb_LED1);

ClockProc:process
begin
    tb_clkMain <= '0';
    wait for 10 NS;
    tb_clkMain <= '1';
    wait for 10 NS;
end process;

StimProc: process
begin
tb_swG15 <= '0';
tb_rstMain <= '1';
wait for 10 ns;
tb_swG15 <= '1';
tb_rstMain <= '0';
wait for 100 ns;
tb_swG15 <= '0';

wait for 100 ns;
end process;
end rtl;