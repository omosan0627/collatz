library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use work.types.all;

entity climber is
	port (
	clk : in std_logic;
	root: in std_logic_vector(9 downto 0);
	init: in std_logic;
	done: out std_logic;
	peak: out std_logic_vector(17 downto 0); --18bit
	len: out std_logic_vector(7 downto 0) --8bit
	);
end climber;

architecture RTL of climber is
	signal root_reg: std_logic_vector(17 downto 0) := (others => '0');
	signal peak_reg: std_logic_vector(17 downto 0) := (others => '0');
	signal len_reg: std_logic_vector(7 downto 0) := (others => '0');

	signal state : std_logic := '0';

begin
	peak <= peak_reg;
	len <= len_reg;
	done <= '1' when root_reg = 1 else '0';

	process(clk)
		variable root_var: std_logic_vector(17 downto 0);
		variable peak_var: std_logic_vector(17 downto 0);
		variable len_var: std_logic_vector(7 downto 0);

		variable shift : std_logic_vector(4 downto 0);
	begin
		if rising_edge(clk) then
			if init = '1' then
				if state = '0' then
					state <= '1';
					root_reg <= ("00000000" & root);
				elsif root_reg /= 1 then --and state = '1'
					root_var := root_reg;
					peak_var := peak_reg;
					len_var := len_reg;

					if root_var(0) = '1' then
						root_var := (root_var(16 downto 0) & '1') + root_var;

						if peak_var < root_var then
							peak_var := root_var;
						end if;

						len_var := len_var + 1;
					end if;

					if root_var(0) = '1' then
						shift := "00000";
					elsif root_var(1) = '1' then
						shift := "00001";
					elsif root_var(2) = '1' then
						shift := "00010";
					elsif root_var(3) = '1' then
						shift := "00011";
					elsif root_var(4) = '1' then
						shift := "00100";
					elsif root_var(5) = '1' then
						shift := "00101";
					elsif root_var(6) = '1' then
						shift := "00110";
					elsif root_var(7) = '1' then
						shift := "00111";
					elsif root_var(8) = '1' then
						shift := "01000";
					elsif root_var(9) = '1' then
						shift := "01001";
					elsif root_var(10) = '1' then
						shift := "01010";
					elsif root_var(11) = '1' then
						shift := "01011";
					elsif root_var(12) = '1' then
						shift := "01100";
					elsif root_var(13) = '1' then
						shift := "01101";
					elsif root_var(14) = '1' then
						shift := "01110";
					elsif root_var(15) = '1' then
						shift := "01111";
					elsif root_var(16) = '1' then
						shift := "10000";
					end if;

					if shift(4) = '1' then
						root_var := "0000000000000000" & root_var(17 downto 16);
						len_var := len_var + 16;
					end if;

					if shift(3) = '1' then
						root_var := "00000000" & root_var(17 downto 8);
						len_var := len_var + 8;
					end if;

					if shift(2) = '1' then
						root_var := "0000" & root_var(17 downto 4);
						len_var := len_var + 4;
					end if;

					if shift(1) = '1' then
						root_var := "00" & root_var(17 downto 2);
						len_var := len_var + 2;
					end if;

					if shift(0) = '1' then
						root_var := "0" & root_var(17 downto 1);
						len_var := len_var + 1;
					end if;

					root_reg <= root_var;
					peak_reg <= peak_var;
					len_reg <= len_var;
				end if;

			end if;
		end if;
	end process;

end RTL;
				

