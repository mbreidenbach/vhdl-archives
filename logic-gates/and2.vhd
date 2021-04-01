-------------------------------------------------
--  File:          and2.vhd
--
--  Entity:        and2
--  Architecture:  df (dataflow)
--  Author:        Matthew Breidenbach
--  Edited:       2/3/2020
--  VHDL'93
--  Description:   Simple 2 gate AND
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity and2 is
	port (A, B : in std_logic;
	Y : out std_logic);
end and2;

architecture df of and2 is
begin
	Y <= A and B;
end;