-- Advanced Digital Electronic module | Prof. Herve Mathias
-- Rilwanu Ar Roiyyaan KASNO | M2 ICS
-- TD 4 version 2
-- traffic lights model with certain amount of delay for each states

Library ieee ;
Use ieee.std_logic_1164.all ;
use ieee.numeric_std.all;

entity feux is
port (clk, raz, button : in  std_logic ;  -- horloge, reset, et bouton poussoir
      r,o,v : out std_logic);		  -- commande des lumières rouge, orange et vert
end entity feux ;

architecture a2 of feux is

type statetype is (SR, SV, SO);		-- états de la machine d'état
signal state, next_state : statetype;  			-- registre d'état
signal tempo : unsigned(5 downto 0);
signal fin_tempo : std_logic;

begin
  process(state, fin_tempo)
  begin
	next_state <= state;
	tempo <= to_unsigned(0, tempo'length);
	case state is
		when SR =>
						if (fin_tempo = '1') then
										next_state <= SV;
						end if;
						tempo <= to_unsigned(45,tempo'length);
		when SV =>
						if (fin_tempo = '1') then
										next_state <= SO;
						end if;
						tempo <= to_unsigned(30,tempo'length);

		when SO =>
						if (fin_tempo = '1') then
										next_state <= SR;
						end if;
						tempo <= to_unsigned(12,tempo'length);
	end case;
  end process;

  process(clk,raz)
  begin
    if (raz='0') then							-- reset asynchrone
        state <= SR ;
    elsif (clk'event and clk='1') then			-- au top d'horloge
      state <= next_state;
    end if ;
  end process;

  -- calcul des sorties en fonction de l'état
  r <= '1' when state = SR else '0';
  v <= '1' when state = SV else '0';
  o <= '1' when state = SO else '0';

  aux : process(clk,raz)
  variable cpt_tempo : unsigned(5 downto 0);
  begin
	if (raz = '0') then
				cpt_tempo := to_unsigned(0, cpt_tempo'length);
		fin_tempo <= '0';
	elsif (clk'event and clk = '1') then
		if (cpt_tempo = tempo) then
			 cpt_tempo := to_unsigned(0, cpt_tempo'length);
		fin_tempo <= '1';
		else
		cpt_tempo := cpt_tempo+1;
		fin_tempo <= '0';
		end if;
	end if;
  end process;
 end a2;
