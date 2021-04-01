------------------------------------------------------
-- Company:   Rochester  Institute  of  Technology (RIT)
-- Engineer: Matthew Breidenbach (mcb7173@rit.edu)
--
-- Create  Date:     1/22/2020
-- Design  Name:     xorN
-- Module  Name:     xorN - dataflow
-- Project  Name:    project_1
-- Target  Devices: Basys3
--
-- Description: N-bit  bitwise  XOR  unit
------------------------------------------------------

library  IEEE;
use  IEEE.STD_LOGIC_1164.ALL;

entity xorN is
    GENERIC (N : INTEGER  := 32); --bit  width
    PORT (
        A : IN  std_logic_vector(N-1  downto  0);
		B : IN  std_logic_vector(N-1  downto  0);
        Y : OUT  std_logic_vector(N-1  downto  0)
        );
end xorN;

architecture  dataflow  of xorN is
begin
    Y <= A xor B;
end  dataflow;