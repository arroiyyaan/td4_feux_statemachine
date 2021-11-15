-- Advanced Digital Electronic module | Prof. Herve Mathias
-- Rilwanu Ar Roiyyaan KASNO | M2 ICS

-- =========================================================================================================
-- TD 4 version 2 and 3
-- faux with press button as asynchronous input from pedestrian
-- the three states of red, green, and orange have respective time of delay which are 40, 30, and 12 seconds
-- pedestrian press button is added
-- it is recognized only if the current state is green and only when it is already on for at least 5 seconds
-- adapted from the given example with modifications
-- =========================================================================================================

-- required library declaration
Library ieee ;
Use ieee.std_logic_1164.all ;
use ieee.numeric_std.all;

------------------------------------------------
-- entity declaration, with one additional input which is asynchronous button
entity feux is
port (clk, raz, button : in  std_logic ;  -- horloge, reset, et bouton poussoir
      r,o,v : out std_logic);		  -- commande des lumières rouge, orange et vert
end entity feux ;

------------------------------------------------

architecture a3 of feux is

-- only three states introduced along with the auxiliary counter tempo
type statetype is (SR, SV, SO);		-- états de la machine d'état
signal state, next_state : statetype;  			-- registre d'état
signal tempo : unsigned(5 downto 0);
signal fin_tempo : std_logic;

-- an auxiliary logic flac is introduced to fulfill the requirement where press button
-- can only be recognized after 5 seconds of green state
signal aux_green : std_logic;

begin

  -- the transition between states happening here in this process
  -- this process only accommodates the normal transition cycle (green - orange - red - green), excluding any asynchrone input
  -- here only current state and fin_tempo are sensed
  process(state, fin_tempo)
  begin

  -- initially, the next state will take the current state
	next_state <= state;

  -- set the tempo
	tempo <= to_unsigned(0, tempo'length);

  -- starting the state evaluation
	case state is

    -- red to green state then final clock is high
		when SR =>
						if (fin_tempo = '1') then
										next_state <= SV;
						end if;
						tempo <= to_unsigned(45,tempo'length);
    -- green to orange state
		when SV =>
						if (fin_tempo = '1') then
										next_state <= SO;
						end if;
						tempo <= to_unsigned(30,tempo'length);
    -- orange to red state, all under the same condition
		when SO =>
						if (fin_tempo = '1') then
										next_state <= SR;
						end if;
						tempo <= to_unsigned(12,tempo'length);
	end case;
  end process;

  -- the process of accommodating the asynchronous input of press button and reset
  process(clk,raz)
  begin
    -- set to red state when system is re-set
    if (raz='0') then		-- reset asynchrone
        state <= SR ;
    -- otherwise, check if the current state is green
    elsif (state = SV) then
      -- if so, check if the button is pressed
      if (button = '0') then
        -- if so, check if the green state has been on for at least for 5 seconds
        if (aux_green = '1') then
          -- if so, set the state to green right away
          state <= SO;
        end if;
      end if;
    -- otherwise, proceed with the normal transition
    else (clk'event and clk='1') then			-- au top d'horloge
      state <= next_state;
    end if ;
  end process;

  -- calcul des sorties en fonction de l'état
  r <= '1' when state = SR else '0'; -- turn red if the current state is SR
  v <= '1' when state = SV else '0'; -- turn green if the current state is SV
  o <= '1' when state = SO else '0'; -- turn orange if the current state is SO

  ------------------------------------------------

  -- the auxiliary counter process happening here
  aux : process(clk,raz)
  variable cpt_tempo : unsigned(5 downto 0);
  begin
    -- reset detection
  	if (raz = '0') then
  		cpt_tempo := to_unsigned(0, cpt_tempo'length);
  		fin_tempo <= '0';
    -- otherwise,
  	elsif (clk'event and clk = '1') then
      -- check if the counter cpt_tempo is equal to the current tempo value for respective active state
  		if (cpt_tempo = tempo) then
        -- if so, set back to zero and activate the next state by sending flag of active fin_tempo
  			cpt_tempo := to_unsigned(0, cpt_tempo'length);
  		  fin_tempo <= '1';
  		else
        -- if not, check if the counter is equal to 5
        if (cpt_tempo = 4) then
          -- if so, activate the flag
          aux_green <= '1';
        end if;
        -- and continue counting and keep the flag fin_tempo deactivated
  		  cpt_tempo := cpt_tempo+1;
  		  fin_tempo <= '0';
  		end if;
  	end if;
  end process;

-- end
end a3;
