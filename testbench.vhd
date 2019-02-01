library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use work.types.all;

entity testbench is
end testbench;

architecture behaviour of testbench is
	component collatz is
		port(
		clk: in std_logic;
		clk_count: out std_logic_vector(31 downto 0);
		top4: out chains4_t
		);	
	end component;

	

	signal clk: std_logic := '0';
	signal clk_count: std_logic_vector(31 downto 0) := (others => '0');
	signal top4: chains4_t;


begin
    collatz_p : collatz port map(
		clk => clk,
		clk_count => clk_count,
		top4 => top4
	);

	




	-- all_done <= '1' when done_9 = '1' and done_7 = '1' else '0';

	
	clockgen: process
	begin
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
	end process;

end behaviour;
