library ieee;
use ieee.std_logic_1164.all;

entity System_Interconnect2 is
  port(
    rst_seq_gen  : in std_logic;  -- Reset for Sequence Generator
    clk_fifo_wr  : in std_logic;  -- Clock for FIFO Write
    clk_fifo_rd  : in std_logic;  -- Clock for FIFO Read
    rst_sorter   : in std_logic;  -- Reset for Sorter
    enable_sorter: in std_logic;  -- Enable signal for Sorter
    output       : out std_logic_vector(7 downto 0);  -- Final output
  );
end entity System_Interconnect2;

architecture Interconnect of System_Interconnect2 is
  -- Signals to connect the components
  signal fifo_data : std_logic_vector(7 downto 0);  -- FIFO output
  signal seq_gen_output : std_logic_vector(7 downto 0);  -- Sequence Generator output

  -- Component declarations
  component Sequence_Generator_ROM is
    port(
      clk             : in std_logic;
      rst             : in std_logic;
      full_flag       : in std_logic;
      output_sequence : out std_logic_vector(7 downto 0)
    );
  end component;

  component fullDesign_pipeline_v1 is
    port(
      clk       : in std_logic;
      reset     : in std_logic;
      enable    : in std_logic;
      ExtInput  : in std_logic_vector(7 downto 0);
      ExtOutput : out std_logic_vector(7 downto 0)
    );
  end component;

begin
  -- Sequence Generator
  seq_gen : Sequence_Generator_ROM
    port map(
      clk => clk_fifo_wr,
      rst => rst_seq_gen,
      full_flag => '0',
      output_sequence => seq_gen_output
    );

  -- Sorter
  sorter : fullDesign_pipeline_v1
    port map(
      clk       => clk_fifo_rd,
      reset     => rst_sorter,
      enable    => enable_sorter,  -- Enabled by external signal
      ExtInput  => seq_gen_output,  -- Input from Sequence Generator
      ExtOutput => output  -- Final output
    );

end architecture Interconnect;
