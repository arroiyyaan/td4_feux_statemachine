-- Advanced Digital Electronic module | Prof. Herve Mathias
-- Rilwanu Ar Roiyyaan KASNO | M2 ICS

-- =================
-- TD 4 version 1
-- feux 1 normale --
-- =================

-- required library declaration
Library ieee ;
Use ieee.std_logic_1164.all ;

------------------------------------------------
-- entity declaration
entity feux is
port (clk, raz : in  std_logic ;  -- horloge, reset, et bouton poussoir
  	r,o,v	: out std_logic ) ;   	   -- commande des lumières rouge, orange et vert
end entity feux ;

------------------------------------------------
architecture a1 of feux is

-- declaration of all six states
type statetype is (S0, S1, S2, S3, S4, S5);   	 -- états de la machine d'état
signal state : statetype; 						 -- registre d'état

begin
  process(clk,raz)
  begin
	if (raz='0') then   						 -- reset asynchrone -- active low reset
    	state <= S0 ;
	elsif (clk'event and clk='1') then   		 -- au top d'horloge
  	case state is   							 -- calcul du nouvel etat
      -- transition of current state to the next one right away
    	when S0 => state <= S1 ;   -- set to state 1 if the current state is state 0
    	when S1 => state <= S2 ;   -- set to state 2 if the current state is state 1
    	when S2 => state <= S3 ;   -- set to state 3 if the current state is state 2
    	when S3 => state <= S4 ;   -- set to state 4 if the current state is state 3
    	when S4 => state <= S5 ;   -- set to state 5 if the current state is state 4
    	when S5 => state <= S0 ;   -- set back to state 0 if the current state is state 5
  	end case ;
	end if ;
  end process;

  -- validate this to the original code
  -- calcul des sorties en fonction de l'état

  -- turn red when the current state is 0, or 1, or 2, otherwise turn off
  r <= '1' when state=S0 or state=S1 or state=S2 else '0' ;
  -- turn green when the current state is 3 or 4, otherwise turn off
  v <= '1' when state=S3 or state=S4 else '0' ;
  -- turn orange when the current state is 5, otherwise turn off
  o <= '1' when state=S5 else '0' ;
end a1;
