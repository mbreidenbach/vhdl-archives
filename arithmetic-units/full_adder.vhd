-------------------------------------------------
--  File:          full_adder.vhd
--
--  Entity:        full_adder
--  Architecture:  df (dataflow)
--  Author:        Matthew Breidenbach
--  Created:       2/27/2020
--  VHDL'93
--  Description:   A simple full adder.
-------------------------------------------------

library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
	port(	A : in std_logic;
			B : in std_logic;
			Cin : in std_logic;
			Y : out std_logic;
			Cout : out std_logic
		);
end entity;

architecture df of full_adder is

begin
	Y <= A XOR B XOR Cin;
	Cout <= (A AND B) OR (A AND Cin) OR (Cin AND B);
	
end architecture;