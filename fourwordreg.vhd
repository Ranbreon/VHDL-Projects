--Four word Register File (4x8)
--Started: August 8, 2019
--Status:  Completed; August 8, 2019
--Main purpose was to creat a 4 word register file using the type "array"


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fourwordreg is
    Port (
            clkMain, wrEnIn      : in STD_LOGIC;
            wAddrIn, rAddrIn    : in STD_LOGIC_VECTOR(1 DOWNTO 0);
            wDataIn               : in STD_LOGIC_VECTOR(7 DOWNTO 0);
            rDataOut               : out STD_LOGIC_VECTOR(7 DOWNTO 0) 
        );
end fourwordreg;

architecture Behavioral of fourwordreg is
CONSTANT ADDRWIDTH  : natural   := 2;
CONSTANT DATAWIDTH  : natural   := 8;
type  mem2dType is array (0 to 2**ADDRWIDTH-1) of
        STD_LOGIC_VECTOR(DATAWIDTH-1 DOWNTO 0);
signal arrayR       : mem2dType;
signal en           : STD_LOGIC_VECTOR(2**ADDRWIDTH-1 DOWNTO 0);        

begin
--4 Registers
fourRegProc: process (clkMain) 
begin
    if (rising_edge (clkMain)) then
        if (en(3) = '1') then
            arrayR(3) <= wDataIn;
        end if;    
        if (en(2) = '1') then
            arrayR(2) <= wDataIn;
        end if;         
        if (en(1) = '1') then
            arrayR(1) <= wDataIn; 
        end if;  
        if (en(0) = '1') then
            arrayR(0) <= wDataIn;    
        end if;  
    end if;
end process;
 
DecodeProc: process (wrEnIn, wAddrIn)
begin
    if (wrEnIn = '0') then
        en  <= (others => '0');
    else
        case wAddrIn is
            when "00" => en <= "0001";
            when "01" => en <= "0010";
            when "10" => en <= "0100";
            when others => en <= "1000";
        end case;        
    end if;
end process;

--Multiplexing
with rAddrIn select rdataOut <=
    arrayR(0) when "00",
    arrayR(1) when "01",
    arrayR(2) when "10",
    arrayR(3) when others;        
        
end Behavioral;
