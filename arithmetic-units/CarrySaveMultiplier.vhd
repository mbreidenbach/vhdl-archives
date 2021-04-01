-------------------------------------------------
--  File:          CarrySaveMultiplier.vhd
--
--  Entity:        CarrySaveMultiplier
--  Architecture:  struct
--  Author:        Matthew Breidenbach
--  Created:       2/27/2020
--  VHDL'93
--  Description:   A carry save multiplier
-------------------------------------------------

library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity CarrySaveMultiplier is
	generic ( 	N : integer := 32);
	port	(   A : in std_logic_vector(N/2 -1 downto 0); --m col
				B : in std_logic_vector(N/2 -1 downto 0); --q row
				Product : out std_logic_vector(N-1 downto 0)
			);
end entity;

architecture multiply_time of CarrySaveMultiplier is
    type mult_array is array (0 to N/2 -1) of std_logic_vector(N/2 - 1 downto 0); --make /2
    signal a_arr : mult_array;
    signal fa : mult_array;
    signal c : mult_array;
	signal p : std_logic_vector(n-1 downto 0);
    
    component full_adder is
        port(    A : in std_logic;
                B : in std_logic;
                Cin : in std_logic;
                Y : out std_logic;
                Cout : out std_logic
            );
    end component;
begin
    gen_rows : for row in 0 to n/2 -1 generate
        gen_cols : for col in 0 to n/2 -1 generate
            ands : a_arr(row)(col) <= A(col) AND B(row);
            r1c0 : if col = 0 and row = 1 generate
                    adder_t0 : full_adder
                        port map(A => a_arr(0)(1), B => a_arr(1)(0), Cin => '0', Y => fa(1)(0), Cout => c(1)(0));
                        p(1) <= fa(1)(0);
					end generate; --r1c0
            r1_mid_cols : if col > 0 and col < n/2 -1 and row =1 generate
                    adder_t1 : full_adder
                        port map(A => a_arr(0)(col+1), B => a_arr(1)(col), Cin => c(1)(col-1), Y => fa(1)(col), Cout => c(1)(col));
					end generate;
			r1_last_col : if col = n/2 -1 and row = 1 generate
					adder_t2 : full_adder
						port map(A => '0', B => a_arr(1)(col), Cin => c(1)(col-1), Y => fa(1)(col), Cout => c(1)(col));
					end generate;
            c0_other_adders : if col = 0 and row > 1 generate
					adder_t3 : full_adder
						port map(A => fa(row-1)(1), B => a_arr(row)(0), Cin => '0', Y => fa(row)(0), Cout => c(row)(0));
						p(row) <= fa(row)(0);
					end generate;
			rx_last_col : if col = n/2 - 1 and row > 1 generate
					adder_t4 : full_adder
						port map(A => c(row-1)(col), B => a_arr(row)(col), Cin => c(row)(col-1), Y => fa(row)(col), Cout => c(row)(col));
					end generate;
			rx_mid_cols : if col > 0 and col < n/2 -1 and row > 1 generate
					adder_t4 : full_adder
						port map(A => fa(row-1)(col+1), B => a_arr(row)(col), Cin => c(row)(col-1), Y => fa(row)(col), Cout => c(row)(col));
					end generate;
			over_half_n_outs : if row = n/2 -1 and col > 0 generate
			         p(row + col) <= fa(row)(col);
			         end generate;
		end generate;
	end generate;
	out_proc : process(a_arr, fa, c) is begin
	   p(0) <= a_arr(0)(0);
	   p(n-1) <= c(n/2 -1)(n/2 -1);
	end process;
	
	prod_proc : process(p) is begin
	Product <= p;
	end process;

				
end architecture;