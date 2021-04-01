-------------------------------------------------
--  File:          fetch_module.vhd
--
--  Entity:        fetch_module
--  Architecture:  behavorial
--  Author:        Matthew Breidenbach
--  Created:       2/6/2020
--  VHDL'93
--  Description:   Fetch Memory Module
-------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity fetch_module is
    Port (  
            clk : in std_logic;
            rst : in std_logic;
            Instruction : out std_logic_vector(31 downto 0)
    );
end fetch_module;

architecture struct of fetch_module is

	component instr_mem_module is
    Port (  
            clk : in std_logic;
            addr : in std_logic_vector(27 downto 0);
            d_out : out std_logic_vector(31 downto 0)
    );
	end component instr_mem_module;
	
	signal PC : std_logic_vector(27 downto 0) := "0000000000000000000000000000";
	signal plus_four : std_logic_vector(27 downto 0) := "0000000000000000000000000100";
	
	begin
	
	mem_mod_comp : instr_mem_module
			port map(clk => clk, addr => PC, d_out => Instruction);

	
	fetch_proc : process(clk, rst) is begin
		if rst = '1' then
                PC <= "0000000000000000000000000000";
		else 
		  if rising_edge(clk) then
		--PC <= PC + 4
			PC <= PC + plus_four; --to_integer(unsigned(PC)) + 4;
		  end if;
		end if;
	end process;

end architecture;