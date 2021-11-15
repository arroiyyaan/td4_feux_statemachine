----------------------------------------------------------
-- projet : thunderbird
-- auteur : P.BENABES
-- description : display the lighting of an old american car
----------------------------------------------------------

-- open the standard libraries
library ieee;
use ieee.std_logic_1164.all ;	-- définit le types std_logic std_logic_vector

-- the TOP level entity
entity clk_div is 

-- defines the generic parameters (project constants)
generic (facteur : integer := 25000000);  -- facteur de division d'horloge. Ici on obtiendra 1 hz à partir de 50 Mhz

-- Input/Outputs definition
port (  RESET   :   in std_logic;		-- 50 Mhz Clock
        CLK_IN  :   in std_logic;		-- 50 Mhz Clock
        CLK_OUT :  out std_logic);	-- 1 Hz clock

		  
end entity; 


architecture a1 of clk_div is 

signal clkcnt : integer range 0 to facteur-1 ;		-- clock divider counter
signal clkout : std_logic;						-- 1 hz clock
begin
	
	divhorl : process(CLK_IN,RESET)										
	begin
		if (RESET='0') then
			 clkout <= '0'  ;			-- the signal clk1hz is inverted ...
			 clkcnt <= 0 ;				-- and the decounter is restarted
		elsif rising_edge(CLK_IN) then	-- at the high speed clock rising edge
		  if ( clkcnt = 0 ) then 		      -- when the decounter has reached its last value ...
			 clkout <= not clkout  ;			-- the signal clk1hz is inverted ...
			 clkcnt <= facteur-1 ;				-- and the decounter is restarted
		  else 
			 clkcnt <= clkcnt - 1   ;			-- else the decounter is decremented
		  end if;
		end if ;
	end process;
		
	CLK_OUT <=  clkout ;
	
end architecture; 


