-------------------------------------------------
--  File:          RegisterFile.vhd
--
--  Entity:        RegisterFile
--  Architecture:  structural
--  Author:        Matthew Breidenbach
--  Created:       2/3/2020
--  VHDL'93
--  Description:   A generic Register File
-------------------------------------------------

library  IEEE;
use  IEEE.STD_LOGIC_1164.ALL;
use  IEEE.NUMERIC_STD.ALL;

entity RegisterFile is
	GENERIC(
		BIT_DEPTH : integer := 32;
		LOG_PORT_DEPTH : integer := 5
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
end entity;

architecture structural of RegisterFile is
	component and2 is
		PORT (
			A : IN  std_logic;
			B : IN  std_logic;
			Y : OUT  std_logic
			);
	end component;
	
	component register_module is
		generic(
			BIT_DEPTH : integer := 8 --Bit depth of signals
		);
		port(
			input 	: in std_logic_vector(BIT_DEPTH-1 downto 0);
			clk_n 	: in std_logic;
			we 		: in std_logic;
			output 	: out std_logic_vector(BIT_DEPTH-1 downto 0)
		);
	end component;
	
	component generic_decoder is
		generic(
			BIT_DEPTH : integer := 8; --Bit depth of signals
			LOG_PORT_DEPTH : integer := 3 --log_2 of the signal width
		);
		port(
			Sel : in std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
			Y	: out std_logic_vector(BIT_DEPTH-1 downto 0)
		);
	end component;
	
	component generic_mux is
		generic(
			BIT_DEPTH : integer := 8; --Bit depth of signals
			LOG_PORT_DEPTH : integer := 3 --log_2 of the signal width
		);
		port(
			X	: in std_logic_vector(((2**LOG_PORT_DEPTH) * BIT_DEPTH)-1 downto 0);
			Sel : in std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
			Y	: out std_logic_vector(BIT_DEPTH-1 downto 0)
		);
	end component;
	
	signal decoder_out : std_logic_vector(BIT_DEPTH-1 downto 0);
	signal and_out_vect : std_logic_vector(2**LOG_PORT_DEPTH-1 downto 0);
	signal reg_out_vect : std_logic_vector(((2**LOG_PORT_DEPTH) * BIT_DEPTH)-1 downto 0) := x"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	signal RD1Start : std_logic_vector(31 downto 0) := x"00000000";
	signal RD2Start : std_logic_vector(31 downto 0) := x"00000000";
	--start generating components
	begin
	decoder_comp : generic_decoder
			generic map (BIT_DEPTH => 32,
						LOG_PORT_DEPTH => 5)
			port map(SEL => Addr3, Y => decoder_out);
						
	--2**LOG_PORT_DEPTH-1
	gen_1 : for i in 2**LOG_PORT_DEPTH-1 downto 0 generate
	and_comp : and2
			port map(A => decoder_out(i), B => we, Y => and_out_vect(i));
	
	register_module_comp : register_module
			generic map(BIT_DEPTH => 32)
			port map(input => wd, clk_n => clk_n, we => and_out_vect(i), output => reg_out_vect(((i+1) * BIT_DEPTH) - 1 downto (i * BIT_DEPTH)));
	end generate;
	
	mux_1_comp : generic_mux
			generic map(BIT_DEPTH => 32, LOG_PORT_DEPTH => 5)
			port map(X => reg_out_vect, Sel => Addr1, Y => RD1Start);
		
	mux_2_comp : generic_mux
			generic map(BIT_DEPTH => 32, LOG_PORT_DEPTH => 5)
			port map(X => reg_out_vect, Sel => Addr2, Y => RD2Start);
	
	RD1 <= RD1Start;
	RD2 <= RD2Start;
end structural;