library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_System_Interconnect2 is
end entity tb_System_Interconnect2;

architecture test of tb_System_Interconnect2 is
  -- Test signals
  signal rst_seq_gen   : std_logic := '0';
  signal clk_fifo_wr   : std_logic := '0';
  signal clk_fifo_rd   : std_logic := '0';
  signal rst_sorter    : std_logic := '0';
  signal enable_sorter : std_logic := '0';
  signal output        : std_logic_vector(7 downto 0);

  -- Unit Under Test (UUT)
  component System_Interconnect2 is
    port(
      rst_seq_gen   : in std_logic;
      clk_fifo_wr   : in std_logic;
      clk_fifo_rd   : in std_logic;
      rst_sorter    : in std_logic;
      enable_sorter : in std_logic;
      output        : out std_logic_vector(7 downto 0)
    );
  end component;

begin
  -- Instantiate the System Interconnect
  uut : System_Interconnect2
    port map(
      rst_seq_gen   => rst_seq_gen,
      clk_fifo_wr   => clk_fifo_wr,
      clk_fifo_rd   => clk_fifo_rd,
      rst_sorter    => rst_sorter,
      enable_sorter => enable_sorter,
      output        => output
    );

  -- Clock generation
  clk_wr_process : process
  begin
    while now < 300 ns loop
      clk_fifo_wr <= not clk_fifo_wr;
      wait for 7.5 ns;
    end loop;
    wait;
  end process;

  clk_rd_process : process
  begin
    while now < 300 ns loop
      clk_fifo_rd <= not clk_fifo_rd;
      wait for 6 ns;
    end loop;
    wait;
  end process;
	

  -- Test sequence
  test_process : process
  begin
    -- Reset sequence
    rst_seq_gen <= '1';
    rst_sorter  <= '1';
    wait for 20 ns;

    rst_seq_gen <= '0';
    rst_sorter  <= '0';
    
    wait for 20 ns;

    -- Enable sorter
    enable_sorter <= '1';
    wait for 100 ns;

    -- End of simulation
    wait;
  end process;

end architecture test;
