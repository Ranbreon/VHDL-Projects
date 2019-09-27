

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO is
    generic (
             width : natural   := 8;
             depth : integer   := 4
        );
    Port (
            clkMain, rstMain    : in STD_LOGIC; 
            keyEn               : in STD_LOGIC; 
            rowIn               : in STD_LOGIC_VECTOR(3 DOWNTO 0);
            colOut             :out STD_LOGIC_VECTOR(3 DOWNTO 0);
            jd      :out STD_LOGIC_VECTOR(7 DOWNTO 0):=(others => '0');   
            --Write Interface
            wrEn                : in STD_LOGIC;
            --wrData              : in STD_LOGIC_VECTOR(width-1 DOWNTO 0);
            wrFull              : out STD_LOGIC;
                            
            --Read Interface    
            rdEn                : in STD_LOGIC;
            -- rdData              : out STD_LOGIC_VECTOR(width-1 DOWNTO 0)
            rdEmpty             : out STD_LOGIC
        );
end FIFO;




architecture Behavioral of FIFO is
type FIFO_DATA is array ( 0 to depth-1) of STD_LOGIC_VECTOR(width-1 DOWNTO 0);
signal rfData   : FIFO_DATA   := (others =>(others => '0'));
signal wrIndex, rdIndex     : integer range 0 to 4 := 0;

signal fCount               : integer range 0 to 4 :=0;
signal full, empty          : STD_LOGIC;
signal clkDiv   :STD_LOGIC_VECTOR(24 DOWNTO 0):=(others=> '0');
signal wrData   :STD_LOGIC_VECTOR(7 DOWNTO 0);

begin
KypdUnit: entity work.Kypd
    Port map (
                clkMain     => clkMain,
                rstMain     => rstMain,
                keyEn       => keyEn,
                rowIn       => rowIn,
                colOut      => colOut,
                wrData      => wrData
                );

full    <= '1' when fCount= depth  else '0';    --red when full
empty   <= '1' when fCount= 0       else '0';   --blue when empty

wrFull  <= full;    --red when full
rdEmpty <= empty;   --blue when empty
jd <= rfData(rdIndex);

clkSloProc:Process(clkMain)
begin
    if (rising_edge (clkMain)) then
        clkDiv <= clkDiv + 1;
    end if;
end process;

CtrlProc: process(clkDiv(24), rstMain)
begin
        if (rstMain = '1') then
            fCount      <= 0;
            wrIndex     <= 0;
            rdIndex     <= 0;
            
         elsif (rising_edge(clkDiv(24))) then
        --Total Number of Words in FIFO;
                if (wrEn = '1' and rdEn = '0') then
                    fCount  <= fCount + 1;
                elsif (wrEn = '0' and rdEn = '1') then
                    fCount  <= fCount - 1;
                end if;
            
        --Track write index and control roll over       
                if (wrEn = '1' and full = '0') then
                    if wrIndex = depth - 1 then
                        wrIndex <= 0;
                    else
                        wrIndex <= wrIndex + 1;
                    end if;                      
                end if;
            
        -- Tracks Read index and cpontrols roll over
                if (rdEn = '1' and empty = '0') then
                    if rdIndex = depth -1 then
                        rdIndex <= 0;
                    else
                        rdIndex <= rdIndex + 1;
                    end if;
                end if;
            
        --Registers input Data for writes
                if (wrEn = '1') then
                    rfData(wrIndex) <= wrData;
                end if;
end if;
end process;

end Behavioral;
