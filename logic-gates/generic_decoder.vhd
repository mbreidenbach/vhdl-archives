-------------------------------------------------
--  File:          generic_decoder.vhd
--
--  Entity:        generic_decoder
--  Architecture:  behavorial
--  Author:        Matthew Breidenbach
--  Created:       2/3/2020
--  VHDL'93
--  Description:   Generic based decoder
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity generic_decoder is
	generic(
		BIT_DEPTH : integer := 8; --Bit depth of signals
		LOG_PORT_DEPTH : integer := 3 --log_2 of the signal width
	);
	port(
		Sel : in std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
		Y	: out std_logic_vector(BIT_DEPTH-1 downto 0)
	);
end generic_decoder;

architecture behavorial of generic_decoder is
	begin
	
	process (sel)
		begin
		Y <= (others => '0');
		Y(to_integer(unsigned(Sel))) <= '1';
	
	end process;

end behavorial;