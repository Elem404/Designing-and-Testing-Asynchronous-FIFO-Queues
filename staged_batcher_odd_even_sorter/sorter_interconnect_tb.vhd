library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity test_fullDesign_pipeline_v1 is
end test_fullDesign_pipeline_v1;

architecture testbench of test_fullDesign_pipeline_v1 is
    -- Declare signals for the test
    signal clk : std_logic := '0';  -- Clock signal
    signal reset : std_logic := '1';  -- Reset signal (active high)
    signal enable : std_logic := '0';  -- Enable signal (active high)
    signal testInput : std_logic_vector(7 downto 0) := (others => '0');  -- Test input signal
    signal testOutput : std_logic_vector(7 downto 0);  -- Test output signal
    
    -- Instantiate the full design
    component fullDesign_pipeline_v1
        Port (
            clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            ExtInput : in std_logic_vector(7 downto 0);
            ExtOutput : out std_logic_vector(7 downto 0);
        );
    end component;

begin
    -- Clock process: Toggle every 10 ns (50 MHz)
    process
    begin
        while now < 400 ns loop -- Run for 100 ns
            clk <= not clk; -- Toggle clock
            wait for 10 ns;
        end loop;
        wait; -- Wait forever
    end process;
    -- Instantiate the pipeline design
    uut : fullDesign_pipeline_v1
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            ExtInput => testInput,
            ExtOutput => testOutput
        );

    -- Test sequence
    process
    begin
        -- Apply reset initially
        reset <= '1';
        wait for 20 ns;  -- Keep reset high to initialize the pipeline

        -- Remove reset and enable the pipeline
        reset <= '0';
        enable <= '1';
        wait for 10 ns;  -- Allow pipeline to settle

        -- Test case 1: All zeros (baseline)
        testInput <= (others => '0');
        wait for 20 ns;  -- Allow data to propagate through pipeline

        -- Test case 2: All ones
        testInput <= (others => '1');
        wait for 20 ns;  -- Allow data to propagate through pipeline
        
        -- Test case 3: Alternating bits (01010101)
        testInput <= "01010101";
        wait for 20 ns;

        -- Test case 4: Alt1rnating bits (10101010)
        testInput <= "10101110";
        wait for 20 ns;

        -- Test case 5: Specific pattern
        testInput <= "11001000";
        wait for 20 ns;
        testInput <= "11X010X0";
        wait for 20 ns;
        -- End of test
        wait;
    end process;

end testbench;
