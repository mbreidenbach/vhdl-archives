-------------------------------------------------
--  File:          writeback_stage.vhd
--
--  Entity:        writeback_stage
--  Architecture:  behav
--  Author:        Matthew Breidenbach
--  Created:       2020
--  VHDL'93
--  Description:   Writeback stage of a MIPS processor.
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity writeback_stage is
	port(	RegWrite, MemToReg : in std_logic;
			ALUResult, ReadData : in std_logic_vector(31 downto 0);
			WriteReg : in std_logic_vector(4 downto 0);
			
			RegWriteOut : out std_logic;
			WriteRegOut : out std_logic_vector(4 downto 0);
			Result : out std_logic_vector(31 downto 0)
		);
end entity;

architecture vdhl_time of writeback_stage is
	
	begin
	
	process(ALUResult, MemToReg, ReadData) is begin
		if MemToReg = '1' then
			Result <= ReadData;
		else
			Result <= ALUResult;
		end if;
	end process;
	
	process(RegWrite, WriteReg) is begin
		WriteRegOut <= WriteReg;
		RegWriteOut <= RegWrite;
	end process;
end architecture;
	