-------------------------------------------------
--  File:          instr_mem_module.vhd
--
--  Entity:        instr_mem_module
--  Architecture:  behavorial
--  Author:        Matthew Breidenbach
--  Created:       2/6/2020
--  VHDL'93
--  Description:   Instruction Memory Module
-------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;



entity instr_mem_module is
    Port (  clk : in std_logic;
            addr : in std_logic_vector(27 downto 0);
            d_out : out std_logic_vector(31 downto 0)
    );
end instr_mem_module;
  
architecture Behavioral of instr_mem_module is

    type t_mem_arr is array(natural range <>) of std_logic_vector(7 downto 0); --each mem addr points to a byte of mem
	constant s_mem_arr : t_mem_arr := ( x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"20", x"01", x"00", x"01", --addi reg0 reg1 1 
										x"20", x"02", x"00", x"01", --addi reg0 reg2 1 
										x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"00", x"22", x"08", x"20", --add reg1 reg2, reg1
										x"AC", x"01", x"00", x"01", --sw reg0 reg1 1
										x"AC", x"02", x"00", x"02", --sw reg0 reg2 2
										x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"00", x"22", x"10", x"20", --add reg1 reg2, reg2
										x"AC", x"01", x"00", x"03", --sw reg0 reg1 3 strong the thrid value
										x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"00", x"00", x"00", x"00",
										x"00", x"22", x"08", x"20", --add reg1 reg2, reg1
										x"AC", x"02", x"00", x"04", --sw reg0 reg2 4
										x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"00", x"00", x"00", x"00",
										x"00", x"22", x"10", x"20", --add reg1 reg2, reg2
										x"AC", x"01", x"00", x"05", --sw reg0 reg1 5
										x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"00", x"00", x"00", x"00",
										x"00", x"22", x"08", x"20", --add reg1 reg2, reg1
										x"AC", x"02", x"00", x"06", --sw reg0 reg2 6
										x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"00", x"00", x"00", x"00",
										x"00", x"22", x"10", x"20", --add reg1 reg2, reg2
										x"AC", x"01", x"00", x"07", --sw reg0 reg1 7
										x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"00", x"00", x"00", x"00",
										x"00", x"22", x"08", x"20", --add reg1 reg2, reg1
										x"AC", x"02", x"00", x"08", --sw reg0 reg2 8
										x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"00", x"00", x"00", x"00",
										x"00", x"22", x"10", x"20", --add reg1 reg2, reg2
										x"AC", x"01", x"00", x"09", --sw reg0 reg1 9
										x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"00", x"00", x"00", x"00",
										x"AC", x"02", x"00", x"0A", --sw reg0 reg2 A
										x"00", x"00", x"00", x"00",  
										x"00", x"00", x"00", x"00",
										x"00", x"00", x"00", x"00",
										x"00", x"00", x"00", x"00",
										(others => '0'));
	
	
	--16 => x"20", 17 => x"08", 18 => x"00", 19 => x"40", others => x"00");
begin
    mem_proc: process(clk) is begin
		if rising_edge(clk) then
			
			if to_integer(unsigned(addr)) < 1024 then
			d_out <= s_mem_arr(to_integer(unsigned(addr))) & s_mem_arr(1 + to_integer(unsigned(addr)))
							& s_mem_arr(2 + to_integer(unsigned(addr))) & s_mem_arr(3 + to_integer(unsigned(addr)));
			else 
				d_out <= x"00000000";
			end if;
		end if;
		
	end process;
end architecture;
