library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity System_Interconnect_tb is
end entity System_Interconnect_tb;

architecture tb of System_Interconnect_tb is
  -- Constants for clock timing
  constant c_CLK_RD_PERIOD : time := 10 ps;
  constant c_CLK_WR_PERIOD : time := 15 ps;

  -- Signal declarations
  signal clk_fifo_wr, clk_fifo_rd : std_logic := '0';
  signal rst_seq_gen, rst_fifo, rst_sorter  : std_logic := '1';
  signal enable_sorter : std_logic := '0';
  signal test_output   : std_logic_vector(7 downto 0);

  -- Unit under test (UUT)
  component System_Interconnect is
    port(
      rst_seq_gen  : in std_logic;
      clk_fifo_wr  : in std_logic;
      clk_fifo_rd  : in std_logic;
      rst_fifo     : in std_logic;
      rst_sorter   : in std_logic;
      enable_sorter: in std_logic;
      output       : out std_logic_vector(7 downto 0);
    );
  end component;

begin

	process
    begin
        while now < 400 ps loop -- Run for 100 ns
            clk_fifo_wr <= not clk_fifo_wr; -- Toggle clock
            wait for c_CLK_WR_PERIOD / 2;
        end loop;
        wait; -- Wait forever
    end process;
    
    process
    begin
        while now < 400 ps loop -- Run for 100 ns
            clk_fifo_rd <= not clk_fifo_rd; -- Toggle clock
            wait for c_CLK_RD_PERIOD / 2;
        end loop;
        wait; -- Wait forever
    end process;



  -- Instantiate the System Interconnect
  UUT: System_Interconnect
    port map(
      rst_seq_gen  => rst_seq_gen,
      clk_fifo_wr  => clk_fifo_wr,
      clk_fifo_rd  => clk_fifo_rd,
      rst_fifo     => rst_fifo,
      rst_sorter   => rst_sorter,
      enable_sorter => enable_sorter,
      output       => test_output
    );

  -- Test Scenario
  process
  begin
    -- Initial state
    rst_seq_gen <= '1';
    rst_fifo <= '1';
    rst_sorter <= '1';
    enable_sorter <= '0';
    wait for 30 ps;  -- Wait for some time

    -- Release resets
    rst_seq_gen <= '0';
    rst_fifo <= '0';
    rst_sorter <= '0';
    wait for 30 ps;  -- Wait for some time

    -- Enable the sorter
    enable_sorter <= '1';

    -- Run the system for a while to allow data to propagate
    wait for 400 ps;

    -- Check the output
    assert test_output /= "00000000"  -- Expected condition
      report "Test Failed: No data in output"
      severity failure;

    -- Stop the simulation
    wait;
  end process;

end architecture tb;
