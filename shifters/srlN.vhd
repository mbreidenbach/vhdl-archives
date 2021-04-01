---------------------------------------------------
-- Company:   Rochester  Institute  of  Technology (RIT)
-- Engineer: Matthew Breidenbach (mcb7173@rit.edu)
--
-- Create  Date:     1/22/2020
-- Design  Name:     sllN
-- Module  Name:     sllN - behavioral
-- Project  Name:    project_1
-- Target  Devices: Basys3
--
-- Description: N-bit  logical  right  shift (SRL) unit
------------------------------------------------------

library  IEEE;
use  IEEE.STD_LOGIC_1164.ALL;
use  IEEE.NUMERIC_STD.ALL;

entity  srlN is
    GENERIC (N : INTEGER  := 32); --bit  width
    PORT (
            A           : IN  std_logic_vector(N-1  downto  0);
            SHIFT_AMT : IN  std_logic_vector(N-1  downto  0);
            Y           : OUT  std_logic_vector(N-1  downto  0));
end  srlN;

architecture  behavioral  of srlN is
    type  shifty_array  is  array(N-1  downto  0) of  
            std_logic_vector(N-1 downto  0);
    signal  aSRL : shifty_array;

begin
    generateSRL: for i in 0 to N-1  generate
        aSRL(i)(N-1-i downto  0) <= A(N-1  downto i);
        right_fill: if i > 0 generate
        aSRL(i)(N-1  downto  N-i)  <= (others =>  '0');
        end  generate  right_fill;
    end  generate  generateSRL;
    shift_if: process (SHIFT_AMT, A, aSRL) begin
         if (to_integer(unsigned(SHIFT_AMT)) > 31) then
            Y <= x"00000000";
        else
            Y <= aSRL(to_integer(unsigned(SHIFT_AMT)));
        end if;
        end process;
end behavioral;
