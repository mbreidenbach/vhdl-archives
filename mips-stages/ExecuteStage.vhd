-------------------------------------------------
--  File:          ExecuteStage.vhd
--
--  Entity:        ExecuteStage
--  Architecture:  struct
--  Author:        Matthew Breidenbach
--  Created:       2/27/2020
--  VHDL'93
--  Description:   the execute stage
-------------------------------------------------

library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity ExecuteStage is
    GENERIC (N : INTEGER  := 32);
	port	(   RegWrite : in std_logic;
				MemToReg : in std_logic;
				MemWrite : in std_logic;
				ALUControl : in std_logic_vector(3 downto 0);
				ALUSrc : in std_logic;
				RegDst : in std_logic;
				RegSrcA : in std_logic_vector(31 downto 0);
				RegSrcB : in std_logic_vector(31 downto 0);
				RtDest : in std_logic_vector(4 downto 0);
				RdDest : in std_logic_vector(4 downto 0);
				SignImm : in std_logic_vector(31 downto 0);
				
				RegWriteOut : out std_logic;
				MemToRegOut : out std_logic;
				MemWriteOut : out std_logic;
				ALUResult : out std_logic_vector(31 downto 0);
				WriteData : out std_logic_vector(31 downto 0);
				WriteReg : out std_logic_vector(4 downto 0)
			);
end entity;

architecture exec of ExecuteStage is
	component alu32 is
		GENERIC (N : INTEGER  := 32); --bit  width
		PORT (
				A    : IN  std_logic_vector(N-1  downto  0);
				B    : IN  std_logic_vector(N-1  downto  0);
				OP   : IN  std_logic_vector(3 downto 0);
				Y    : OUT  std_logic_vector(N-1  downto  0)
			);
	end  component;
	
	signal ALU_SRCB : std_logic_vector(N-1 downto 0);
	signal RegWriteResult : std_logic_vector(4 downto 0);
	
	begin
	   dumbb_porc : process(RegWrite, MemToReg, MemWrite, RegSrcB, RegWriteResult) begin
		RegWriteOut <= RegWrite;
		MemToRegOut <= MemToReg;
		MemWriteOut <= MemWrite;
		WriteData <= RegSrcB;
		WriteReg <= RegWriteResult;
		end process;
		
		ALU_mux : process(ALUSrc, RegSrcB, SignImm) begin
			 if ALUSrc = '0' then
				ALU_SRCB <= RegSrcB;
			else
				ALU_SRCB <= SignImm;
			end if;
		end process;
		
		WriteReg_mux : process(RegDst, RtDest, RdDest) begin
			if RegDst = '0' then
				RegWriteResult <= RtDest;
			else
				RegWriteResult <= RdDest;
			end if;
		end process;
		
		ALU_comp : alu32
			generic map(N => 32)
			port map(A =>RegSrcA, B => ALU_SRCB, OP => ALUControl, Y => ALUResult);
end architecture;
