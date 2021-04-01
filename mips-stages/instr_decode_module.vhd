-------------------------------------------------
--  File:          instr_decode_module.vhd
--
--  Entity:        instr_decode_module
--  Architecture:  struct
--  Author:        Matthew Breidenbach
--  Created:       2/6/2020
--  VHDL'93
--  Description:   Instruction Decoding Module
-------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity instr_decode_module is
	port(	clk : in std_logic;
			Instruction : in std_logic_vector(31 downto 0);
			RegWriteAddr : in std_logic_vector(4 downto 0);
			RegWriteData : in std_logic_vector(31 downto 0);
			RegWriteEn : in std_logic;
			
			RegWrite : out std_logic;
			MemtoReg : out std_logic;
			MemWrite : out std_logic;
			ALUControl : out std_logic_vector(3 downto 0);
			ALUSrc : out std_logic;
			RegDst : out std_logic;
			RD1 : out std_logic_vector(31 downto 0);
			RD2 : out std_logic_vector(31 downto 0);
			RtDest : out std_logic_vector(4 downto 0);
			RdDest : out std_logic_vector(4 downto 0);
			ImmOut : out std_logic_vector(31 downto 0)
		);
	end entity;
	
architecture struct of instr_decode_module is
	
	component RegisterFile is
		GENERIC(
		BIT_DEPTH : integer := 8;
		LOG_PORT_DEPTH : integer := 3
	);
	PORT (
	------------ INPUTS ---------------
		clk_n	: in std_logic;
		we		: in std_logic;
		Addr1	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --read address 1
		Addr2	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --read address 2
		Addr3	: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0); --write address
		wd		: in std_logic_vector(BIT_DEPTH-1 downto 0); --write data, din

	------------- OUTPUTS -------------
		RD1		: out std_logic_vector(BIT_DEPTH-1 downto 0); --Read from Addr1
		RD2		: out std_logic_vector(BIT_DEPTH-1 downto 0) --Read from Addr2
	);
	end component;
	
	component cu_module is
	port(	Opcode : in std_logic_vector(5 downto 0);
			Funct : in std_logic_vector(5 downto 0);
			
			RegWrite : out std_logic;
			MemToReg : out std_logic;
			MemWrite : out std_logic;
			ALUControl : out std_logic_vector(3 downto 0);
			ALUSrc : out std_logic;
			RegDst : out std_logic
		);
	end component;
	
	signal not_clk : std_logic;
begin
	not_clk <= NOT(clk);
	RtDest <= Instruction(20 downto 16);
	RdDest <= Instruction(15 downto 11);
	ImmOut <= std_logic_vector(resize(signed(Instruction(15 downto 0)),32));
	
	

	RegFile_comp : RegisterFile
		generic map(BIT_DEPTH => 32,
					LOG_PORT_DEPTH => 5)
		port map(	clk_n => not_clk, we => RegWriteEn, Addr1 => Instruction(25 downto 21),
					Addr2 => Instruction(20 downto 16), Addr3 => RegWriteAddr,
					wd => RegWriteData, RD1 => RD1, RD2 => RD2);
	
	ControlUnit_comp : cu_module
		port map(	Opcode => Instruction(31 downto 26), Funct => Instruction(5 downto 0),
					RegWrite => RegWrite, MemToReg => MemToReg, MemWrite => MemWrite,
					ALUControl => ALUControl, ALUSrc => ALUSrc, RegDst => RegDst);
end architecture;