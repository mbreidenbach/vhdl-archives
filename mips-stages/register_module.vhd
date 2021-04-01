-------------------------------------------------
--  File:          register_module.vhd
--
--  Entity:        register_module
--  Architecture:  behavorial
--  Author:        Matthew Breidenbach
--  Created:       2/3/2020
--  VHDL'93
--  Description:   Represents the module that holds a generic register. Has own write enable and clock input.
-------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_module is
	generic(
		BIT_DEPTH : integer := 8 --Bit depth of signals
	);
	port(
		input 	: in std_logic_vector(BIT_DEPTH-1 downto 0);
		clk_n 	: in std_logic;
		we 		: in std_logic;
		output 	: out std_logic_vector(BIT_DEPTH-1 downto 0) := x"00000000"
	);
end register_module;

architecture behavorial of register_module is
	signal default_32 : std_logic_vector(31 downto 0) := x"00000000";
	begin
	output <= default_32;
	process (clk_n) begin
		if falling_edge(clk_n) then
			if we = '1' then
				default_32 <= input;
			end if;
		end if;
	end process;
end behavorial;