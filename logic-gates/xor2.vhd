-------------------------------------------------
--  File:          xor2.vhd
--
--  Entity:        xor2
--  Architecture:  df (dataflow)
--  Author:        Matthew Breidenbach
--  Edited:       2/27/2020
--  VHDL'93
--  Description:   Simple 2 gate XOR
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity xor2 is
	port (A, B : in std_logic;
	Y : out std_logic);
end xor2;

architecture df of xor2 is
begin
	Y <= A XOR B;
end;