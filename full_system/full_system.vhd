library ieee;
use ieee.std_logic_1164.all;

entity System_Interconnect is
  port(
    rst_seq_gen  : in std_logic;  -- Reset for Sequence Generator
    clk_fifo_wr  : in std_logic;  -- Clock for FIFO Write
    clk_fifo_rd  : in std_logic;  -- Clock for FIFO Read
    rst_fifo     : in std_logic;  -- Reset for FIFO
    rst_sorter   : in std_logic;  -- Reset for Sorter
    enable_sorter: in std_logic;  -- Enable signal for Sorter
    output : out std_logic_vector(7 downto 0);
  );
end entity System_Interconnect;

architecture Interconnect of System_Interconnect is
  -- Signals used as wires to connect the components
  signal fifo_full, fifo_empty   : std_logic;
  signal fifo_data               : std_logic_vector(7 downto 0);  -- FIFO output
  signal seq_gen_output          : std_logic_vector(7 downto 0);  -- Sequence Generator output

  --Component decleration
  component Sequence_Generator_ROM is
    port(
      clk : in std_logic;
        rst : in std_logic;
        full_flag : in std_logic;
        output_sequence : out std_logic_vector(7 downto 0)
    );
  end component;

  component fifo is
    generic (
      g_DATA_WIDTH : positive := 8;
      g_ADDR_WIDTH : positive := 4;
    );
    port(
      i_CLK_WR    : in  std_logic;
      i_INC_WR    : in  std_logic;
      i_RST_WR    : in  std_logic;
      i_DAT_WR    : in  std_logic_vector(7 downto 0);
      o_FULL_FLAG : out std_logic;
      i_CLK_RD    : in  std_logic;
      i_INC_RD    : in  std_logic;
      i_RST_RD    : in  std_logic;
      o_DAT_RD    : out std_logic_vector(7 downto 0);
      o_EMPTY_FLAG: out std_logic;
    );
  end component;

  component fullDesign_pipeline_v1 is
    port(
      clk       : in std_logic;
      reset     : in std_logic;
      enable    : in std_logic;
      ExtInput  : in std_logic_vector(7 downto 0);
      ExtOutput : out std_logic_vector(7 downto 0);
    );
  end component;

begin
  -- Sequence Generator
  seq_gen : Sequence_Generator_ROM
    port map(
      clk => clk_fifo_wr,
      rst => rst_seq_gen,
      full_flag => fifo_full,
      output_sequence => seq_gen_output
    );

  -- FIFO
  fifo_inst : fifo
    port map(
      i_CLK_WR    => clk_fifo_wr,
      i_INC_WR    => '1',  -- Write enable
      i_RST_WR    => rst_fifo,
      i_DAT_WR    => seq_gen_output,  -- Data from Sequence Generator
      o_FULL_FLAG => fifo_full,

      i_CLK_RD    => clk_fifo_rd,
      i_INC_RD    => not fifo_empty,  -- Read enable
      i_RST_RD    => rst_fifo,
      o_DAT_RD    => fifo_data,  -- Output data to Sorter
      o_EMPTY_FLAG => fifo_empty
    );

  -- Sorter
  sorter : fullDesign_pipeline_v1
    port map(
      clk       => clk_fifo_rd,
      reset     => rst_sorter,
      enable    => not fifo_empty,
      ExtInput  => fifo_data,  -- Input from FIFO
      ExtOutput => output-- Final output
    );
end architecture Interconnect;
