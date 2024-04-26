library ieee;
use ieee.std_logic_1164.all;

entity Sequence_Generator_TB is
end Sequence_Generator_TB;

architecture tb_arch of Sequence_Generator_TB is
    constant CLK_PERIOD : time := 10 ns; -- Clock period (10 ns)

    -- Declare component for Sequence_Generator entity
    component Sequence_Generator_ROM is
       port (
        clk : in std_logic;
        rst : in std_logic;
        full_flag : in std_logic;
        output_sequence : out std_logic_vector(7 downto 0)
    );
    end component;

    signal clk, rst : std_logic := '0'; -- Clock and Reset signals
    signal output_sequence : std_logic_vector(7 downto 0); -- Output sequence signal
begin
    -- Instantiate the Sequence_Generator module
    dut : Sequence_Generator_ROM
        port map (
            clk => clk,
            rst => rst,
            full_flag => '0',
            output_sequence => output_sequence
        );

    -- Clock process
    process
    begin
        while now < 100 ns loop -- Run for 100 ns
            clk <= not clk; -- Toggle clock
            wait for CLK_PERIOD / 2;
        end loop;
        wait; -- Wait forever
    end process;

    -- Reset process
    process
    begin
        rst <= '1'; -- Assert reset
        wait for 20 ns; -- Hold reset for 20 ns
        rst <= '0'; -- Deassert reset
        wait for 100 ns; -- Wait for 50 ns
        wait; -- Wait forever
    end process;

end architecture tb_arch;