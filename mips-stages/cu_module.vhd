-------------------------------------------------
--  File:          cu_module.vhd
--
--  Entity:        cu_module
--  Architecture:  behavorial
--  Author:        Matthew Breidenbach
--  Created:       2/6/2020
--  VHDL'93
--  Description:   Control Unit Module
-------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cu_module is
	port(	Opcode : in std_logic_vector(5 downto 0);
			Funct : in std_logic_vector(5 downto 0);
			
			RegWrite : out std_logic;
			MemToReg : out std_logic;
			MemWrite : out std_logic;
			ALUControl : out std_logic_vector(3 downto 0);
			ALUSrc : out std_logic;
			RegDst : out std_logic
		);
end entity;

architecture behavorial of cu_module is

begin
	--this is gonna be disgusting
	RegWrite_proc : with Opcode select
		RegWrite <=	'1' when "000000", --R-Type
					'1' when "001000", --ADDI
					'1' when "001100", --ANDI
					'1' when "001101", --ORI
					'1' when "001110", --XORI
					'1' when "100011", --LW
					'0' when others; --SW
	
	MemToReg_proc : with Opcode select
		MemToReg <=	'1' when "100011", --LW
					'0' when others; -- R-Type, ADDI, ANDI, ORI, XORI
					--Dont care: SW
	
	MemWrite_proc : with Opcode select
		MemWrite <=	'1' when "101011", --SW
					'0' when others; -- R-Type, ADDI, ANDI, ORI, XORI, LW
	
	ALUSrc_proc : with Opcode select
		ALUSrc <=	'1' when "001000", --ADDI
					'1' when "001100", --ANDI
					'1' when "001101", --ORI
					'1' when "001110", --XORI
					'1' when "100011", --LW
					'1' when "101011", --SW
					'0' when others; -- R-Type
	
	RegDst_proc : with Opcode select
		RegDst <=	'1' when "000000", --R-Type
					'0' when others; --LW ADDI, ANDI, ORI, XORI
					--Dont care: SW
	
	ALUControl_proc : process(Opcode, Funct) begin
		if Opcode = "000000" then --R-Type
			if Funct = "100000" then --ADD
				ALUControl <= "0100";
			elsif Funct = "100100" then --AND
				ALUControl <= "1010";
			elsif Funct = "011001" then --MULTU
				ALUControl <= "0110";
			elsif Funct = "100101" then --OR
				ALUControl <= "1000";
			elsif Funct = "000000" then --SLL
				ALUControl <= "1100";
			elsif Funct = "000011" then --SRA
				ALUControl <= "1110";
			elsif Funct = "000010" then --SRL
				ALUControl <= "1101";
			elsif Funct = "100010" then --SUB
				ALUControl <= "0101";
			elsif Funct = "100110" then --XOR
				ALUControl <= "1011";
			else
			     ALUControl <= "0000"; --NOOP
			end if;
		elsif Opcode = "001100" then --ANDI
			ALUControl <= "1010";
		elsif Opcode = "001101" then  --ORI
			ALUControl <= "1000";
		elsif Opcode = "001110" then --XORI
			ALUControl <= "1011";
		else --Opcode = "101011" then --SW / Opcode = "100011" then --LW /Opcode = "001000" then --ADDI
			ALUControl <= "0100";
		end if;
	end process;
end architecture;
		