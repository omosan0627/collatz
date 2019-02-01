library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use work.types.all;

entity collatz is
	port(
	clk: in std_logic;
	clk_count: out std_logic_vector(31 downto 0);
	top4: out chains4_t
	);
end collatz;

architecture RTL of collatz is
	component climber is
		port (
		clk : in std_logic;
		root: in std_logic_vector(9 downto 0);
		init: in std_logic;
		done: out std_logic;
		peak: out std_logic_vector(17 downto 0); --18bit
		len: out std_logic_vector(7 downto 0) --8bit
		);
	end component;	

	component sorter is
		port (
			clk   : in  std_logic := '0';
			chain : in  chain_t := ((others => '0'), (others => '0'), (others => '0'));
			top4  : out chains4_t := (others => ((others => '0'), (others => '0'), (others => '0')))
		);
	end component;

	constant OUT_SIZE : integer := 256;

	type root_t is array(0 to OUT_SIZE - 1) of std_logic_vector(9 downto 0);
	signal root: root_t := (others => (others => '0'));

	type init_t is array(0 to OUT_SIZE - 1) of std_logic;
	signal init: init_t := (others => '0');

	type done_t is array(0 to 2 * OUT_SIZE - 2) of std_logic;
	signal done: done_t;

	type peak_t is array(0 to OUT_SIZE - 1) of std_logic_vector(17 downto 0);
	signal peak: peak_t;

	type len_t is array(0 to OUT_SIZE - 1) of std_logic_vector(7 downto 0);
	signal len: len_t;

	signal chain_reg: chain_t := ((others => '0'), (others => '0'), (others => '0'));

	signal state : std_logic_vector(1 downto 0) := "11";
	signal root_reg : std_logic_vector(9 downto 0) := "1111111101";

	signal root_at: integer := 0;
	signal all_done: std_logic := '0';
	signal clk_count_reg: std_logic_vector(31 downto 0) := (others => '0');

begin

	clk_count <= clk_count_reg;

	sorter_p: sorter port map(
		clk => clk,
		chain => chain_reg,
		top4 => top4
	);

	GEN_CLIMB: for I in 0 to OUT_SIZE - 1 generate
		CX: climber port map
			(clk, root(I), init(I), done(I + OUT_SIZE - 1), peak(I), len(I));
	end generate GEN_CLIMB;

	GEN_DONE: for I in OUT_SIZE - 2 downto 0 generate
		done(I) <= done(I * 2 + 1) and done(I * 2 + 2);
	end generate GEN_DONE;


	process(clk)
	begin
		if rising_edge(clk) then
			if root_at < 214 then
				init(root_at) <= '1';
				root(root_at) <= root_reg;

				root_at <= root_at + 1;

				if root_at = 42 then
					root_reg <= "1111111111";
				else
					root_reg <= root_reg - 6;
				end if;

			end if;
			if done(1) = '1' and done(5) = '1' and done(27) = '1'
				and done(115) = '1' and done(233) = '1' then
				if root_at = 214 then
					root_at <= 0;
				elsif root_at < 214 then
					chain_reg <= (root(root_at), peak(root_at), len(root_at));
					root_at <= root_at + 1;

					if root_at = 213 then
						root_at <= 215;
						all_done <= '1';
					end if;

				end if;
			end if;

			if all_done = '0' then
				clk_count_reg <= clk_count_reg + 1;
			end if;
		end if;
	end process;

end RTL;

