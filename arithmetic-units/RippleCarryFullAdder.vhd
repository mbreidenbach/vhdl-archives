-------------------------------------------------
--  File:          RippleCarryFullAdder.vhd
--
--  Entity:        RippleCarryFullAdder
--  Architecture:  struct
--  Author:        Matthew Breidenbach
--  Created:       2/27/2020
--  VHDL'93
--  Description:   Ripple Carry Full Adder/Subtractor
-------------------------------------------------

library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity RippleCarryFullAdder is
	generic ( 	N : integer := 32);
	port	(	OP : in std_logic;
				A : in std_logic_vector(N-1 downto 0);
				B : in std_logic_vector(N-1 downto 0);
				Sum : out std_logic_vector(N-1 downto 0)
			);
end entity;

architecture struct of RippleCarryFullAdder is
	component full_adder is
		port(	A : in std_logic;
			B : in std_logic;
			Cin : in std_logic;
			Y : out std_logic;
			Cout : out std_logic
		);
	end component;
	
	component xor2 is
		port (	A, B : in std_logic;
				Y : out std_logic);
	end component;
	
	signal Couts : std_logic_vector(N-1 downto 0);
	signal BXOR : std_logic_vector(N-1 downto 0);
begin
	xor_generate : for i in N-1 downto 0 generate
		xor_comps : xor2
			port map(A => OP, B => B(i), Y => BXOR(i));
	end generate;
	
	RCFA0 : full_adder
		port map(A => A(0), B => BXOR(0), Cin => OP, Y => Sum(0), Cout => Couts(0));
	RCFA_generate : for i in N-1 downto 1 generate
		RCFA_rest : full_adder
			port map(A => A(i), B => BXOR(i), Cin => Couts(i-1), Y => Sum(i), Cout => Couts(i));
	end generate;

end architecture;