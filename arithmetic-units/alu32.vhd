---------------------------------------------------
-- Company:   Rochester  Institute  of  Technology (RIT)
-- Engineer: Matthew Breidenbach (mcb7173@rit.edu)
--
-- Create  Date:     1/16/20
-- Design  Name:     alu32
-- Module  Name:     alu32 - structural
-- Project  Name:    project_1
-- Target  Devices: Basys3
--
-- Description: Partial 32-bit  Arithmetic  Logic  Unit
------------------------------------------------------

library  IEEE;
use  IEEE.STD_LOGIC_1164.ALL;
use  IEEE.NUMERIC_STD.ALL;

entity  alu32 is
    GENERIC (N : INTEGER  := 32); --bit  width
    PORT (
            A    : IN  std_logic_vector(N-1  downto  0);
            B    : IN  std_logic_vector(N-1  downto  0);
            OP   : IN  std_logic_vector(3 downto 0);
            Y    : OUT  std_logic_vector(N-1  downto  0)
        );
end  alu32;

architecture  structural  of alu32 is
--Declare OR component
Component orN is
    GENERIC (N : INTEGER  := 32); --bit  width
    PORT (
        A : IN  std_logic_vector(N-1  downto  0);
		B : IN  std_logic_vector(N-1  downto  0);
        Y : OUT  std_logic_vector(N-1  downto  0)
        );
	end Component;
	
--Declare AND component
Component andN is
    GENERIC (N : INTEGER  := 32); --bit  width
    PORT (
        A : IN  std_logic_vector(N-1  downto  0);
		B : IN  std_logic_vector(N-1  downto  0);
        Y : OUT  std_logic_vector(N-1  downto  0)
        );
	end Component;
	
--Declare XOR component
Component xorN is
    GENERIC (N : INTEGER  := 32); --bit  width
    PORT (
        A : IN  std_logic_vector(N-1  downto  0);
		B : IN  std_logic_vector(N-1  downto  0);
        Y : OUT  std_logic_vector(N-1  downto  0)
        );
	end Component;

-- Declare  the  shift  left  component
Component  sllN is
    GENERIC (N : INTEGER  := 4); --bit  width
    PORT (
            A           : IN  std_logic_vector(N-1  downto  0);
            SHIFT_AMT : IN  std_logic_vector(N-1  downto  0);
            Y           : OUT  std_logic_vector(N-1  downto  0)
        );
    end  Component;
    

--Declare shift right component
Component  srlN is
    GENERIC (N : INTEGER  := 32); --bit  width
    PORT (
            A           : IN  std_logic_vector(N-1  downto  0);
            SHIFT_AMT : IN  std_logic_vector(N-1  downto  0);
            Y           : OUT  std_logic_vector(N-1  downto  0));
	end Component;
	
--Declare shift right (arithmetic) component
Component  sraN is
    GENERIC (N : INTEGER  := 32); --bit  width
    PORT (
            A           : IN  std_logic_vector(N-1  downto  0);
            SHIFT_AMT : IN  std_logic_vector(N-1  downto  0);
            Y           : OUT  std_logic_vector(N-1  downto  0));
	end Component;
	
--Declare adder/subtype
Component RippleCarryFullAdder is
	generic ( 	N : integer := 32);
	port	(	OP : in std_logic;
				A : in std_logic_vector(N-1 downto 0);
				B : in std_logic_vector(N-1 downto 0);
				Sum : out std_logic_vector(N-1 downto 0)
			);
end component;

component CarrySaveMultiplier is
	generic ( 	N : integer := 32);
	port	(   A : in std_logic_vector(N/2 -1 downto 0); --m col
				B : in std_logic_vector(N/2 -1 downto 0); --q row
				Product : out std_logic_vector(N-1 downto 0)
			);
end component;
	
    signal  or_result : std_logic_vector (N-1  downto  0);
	signal  and_result : std_logic_vector (N-1  downto  0);
	signal  xor_result : std_logic_vector (N-1  downto  0);
	signal  sll_result : std_logic_vector (N-1  downto  0);
	signal  srl_result : std_logic_vector (N-1  downto  0);
	signal  sra_result : std_logic_vector (N-1  downto  0);
	signal  RCFA_result : std_logic_vector(N-1  downto  0);
	signal mult_result : std_logic_vector(N-1 downto 0);
	

begin
    -- Instantiate  the  or
	or_comp: orN
		generic map (N => 32)
		port map (A => A, B => B, Y => or_result);
	
	-- Instantiate the and
	and_comp: andN
		generic map (N => 32)
		port map (A => A, B => B, Y => and_result);
	
	--Instantiate the xor
	xor_comp: xorN
		generic map (N => 32)
		port map (A => A, B => B, Y => xor_result);
	
	--Instantiate the sll
	srl_comp: srlN
		generic map (N => 32)
		port map (A => A, SHIFT_AMT => B, Y => srl_result);
    
    -- Instantiate  the  SLL  unit
    sll_comp: sllN
        generic  map ( N => 32)
        port  map ( A=> A, SHIFT_AMT => B, Y => sll_result );
		
		
	sra_comp: sraN
		generic map (N => 32)
		port map (A => A, SHIFT_AMT => B, Y => sra_result);
	
	RCFA_comp : RippleCarryFullAdder
		generic map (N => 32)
		port map (OP => OP(0), A => A, B => B, Sum => RCFA_result);
	
	mult_comp : CarrySaveMultiplier
		generic map (N => 32)
		port map (A => A(N/2 -1 downto 0), B => B(N/2 -1 downto 0), Product => mult_result);
		
    -- Use OP to  control  which  operation  to show/perform
	with OP select Y <=
		or_result  when "1000",
		and_result when "1010",
		xor_result when "1011",
		sll_result when "1100",
		srl_result when "1101",
		sra_result when "1110",
		mult_result when "0110",
		RCFA_result when others;
		

end  structural;