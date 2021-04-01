-------------------------------------------------
--  File:          data_memory.vhd
--
--  Entity:        data_memory
--  Architecture:  behav
--  Author:        Matthew Breidenbach
--  Created:       2020
--  VHDL'93
--  Description:   Used for memory stage of a MIPS processor.
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity data_memory is
	generic(RAM_ADDR_BITS : integer := 10; --(ADDR_SPACE)
			RAM_WIDTH : integer := 32); --(WIDTH)
	port(	CLK, WE : in std_logic;
			A : in std_logic_vector(RAM_ADDR_BITS-1 downto 0); --addr
			WD : in std_logic_vector(RAM_WIDTH-1 downto 0); --d_in
			SWITCHES : in std_logic_vector(15 downto 0);
			RD : out std_logic_vector(RAM_WIDTH-1 downto 0)--;
			--SEVEN_SEG : out std_logic_vector(15 downto 0)
		);
end entity;
	
architecture vhdl_time of data_memory is

	type mem_arr is array(integer range <>) of std_logic_vector(RAM_WIDTH-1 downto 0);
	signal mips_mem : mem_arr((2**RAM_ADDR_BITS)-1 downto 0) := (0 => x"00000001", others => x"00000000");
	
	begin
	
	process(CLK) is begin
		if rising_edge(CLK) then
			if WE = '1' then
				mips_mem(to_integer(unsigned(A))) <= WD;
			end if;
		end if;
	end process;
	
	process(CLK) is begin
		if rising_edge(CLK) then
			if to_integer(unsigned(A)) = 1023 then
				if WE = '1' then
					--SEVEN_SEG <= WD(15 downto 0);
				end if;
			end if;
		end if;
	end process;
	
	process(A, SWITCHES) is begin
		if to_integer(unsigned(A)) = 1022 then
			RD <= x"0000" & SWITCHES;
		else
			RD <= mips_mem(to_integer(unsigned(A)));
		end if;
	end process;
end architecture;