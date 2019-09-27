
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_fourwordreg is
--  Port ( );
end TB_fourwordreg;

architecture Behavioral of TB_fourwordreg is
component fourwordreg
    Port (
            clkMain, wrEnIn     : in STD_LOGIC;
            wAddrIn, rAddrIn    : in STD_LOGIC_VECTOR(1 DOWNTO 0);
            wDataIn             : in STD_LOGIC_VECTOR(7 DOWNTO 0);
            rDataOut            : out STD_LOGIC_VECTOR(7 DOWNTO 0) 
            );   
end component;  
signal tb_clkMain,tb_wrEnIn        : STD_LOGIC                     :='0';
signal tb_wAddrin, tb_rAddrIn   : STD_LOGIC_VECTOR(1 DOWNTO 0)  := "00";
signal tb_wDataIn                  : STD_LOGIC_VECTOR(7 DOWNTO 0)  := "01100011";
signal tb_rDataOut                 : STD_LOGIC_VECTOR(7 DOWNTO 0);


begin
uut: fourwordreg Port Map(
    clkMain     => tb_clkMain,
    wrEnIn      => tb_wrEnIn,
    wAddrIn     => tb_wAddrIn,
    rAddrIn     => tb_rAddrIn,
    wDataIn     => tb_wDataIn,
    rDataOut    => tb_rDataOut);
    
CLOCK:process
begin
    tb_clkMain <= '0';
    wait for 15 NS;
    tb_clkMain <= '1';
    wait for 15 NS;
end process;
        
STIM_PROC: process
begin
    tb_wrEnIn <= '0';
    tb_rAddrIn <= "00";
     tb_wAddrin <= "00"; --write to register 0
    wait for 10 ns;
    tb_wrEnIn <= '1';
    tb_wDataIn <= "01100011";
    tb_wAddrin <= "00"; --write to register 0
    wait for 50 ns;
    tb_wDataIn <= "00000011";
    tb_wAddrin <= "01"; --write to register 1
    wait for 50 ns;
    tb_wDataIn <= "00000111";
    tb_wAddrin <= "10"; --write to register 2
    wait for 50 ns;
    tb_wDataIn <= "00001111";
    tb_wAddrin <= "11"; --write to register 3
    wait for 50 ns;
    tb_rAddrIn <= "00"; --read to register 1
    wait for 50 ns;
    tb_rAddrIn <= "01"; --read to register 1
    wait for 50 ns;
    tb_rAddrIn <= "10"; --read to register 0
    wait for 50 ns;
    tb_rAddrIn <= "11"; --read to register 0
    wait for 50 ns;
    tb_rAddrIn <= "01"; --read to register 0
    wait for 200 ns;
end process;   
end Behavioral;
