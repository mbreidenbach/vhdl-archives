-------------------------------------------------
--  File:          memory_stage.vhd
--
--  Entity:        memory_stage
--  Architecture:  behav
--  Author:        Matthew Breidenbach
--  Created:       2020
--  VHDL'93
--  Description:   Memory stage of a MIPS processor.
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity memory_stage is
	port(	clk, RegWrite, MemToReg, MemWrite : in std_logic;
			WriteReg : in std_logic_vector(4 downto 0);
			ALUResult : in std_logic_vector(31 downto 0);
			WriteData : in std_logic_vector(31 downto 0);
			Switches : in std_logic_vector(15 downto 0);
			
			RegWriteOut, MemToRegOut : out std_logic;
			WriteRegOut : out std_logic_vector(4 downto 0);
			MemOut : out std_logic_vector(31 downto 0);
			ALUResultOut : out std_logic_vector(31 downto 0)--;
			--Active_Digit : out (4 downto 0);
			--Seven_Seg_Digit : out (6 downto 0)
		);
end entity;

architecture behav of memory_stage is

	component data_memory is
		generic(RAM_ADDR_BITS : integer := 10;
				RAM_WIDTH : integer := 32);
		port(	CLK, WE : in std_logic;
				A : in std_logic_vector(RAM_ADDR_BITS-1 downto 0);
				WD : in std_logic_vector(RAM_WIDTH-1 downto 0);
				SWITCHES : in std_logic_vector(15 downto 0);
				RD : out std_logic_vector(RAM_WIDTH-1 downto 0)--;
				--SEVEN_SEG : out std_logic_vector(15 downto 0)
			);
	end component;
	
	--signal seven_seg_inner : std_logic_vector(15 downto 0);
	
	begin
	
	data_mem_comp : data_memory
		generic map(RAM_ADDR_BITS => 10,
				RAM_WIDTH => 32)
		port map(CLK => clk, WE => MemWrite, A => ALUResult(9 downto 0), WD => WriteData, SWITCHES => Switches,
				RD => MemOut-- ,SEVEN_SEG => seven_seg_inner
				);
	
	process(RegWrite, MemToReg, WriteReg, ALUResult)is begin
		RegWriteOut <= RegWrite;
		MemToRegOut <= MemToReg;
		WriteRegOut <= WriteReg;
		ALUResultOut <= ALUResult;
	end process;
end architecture;
		
	