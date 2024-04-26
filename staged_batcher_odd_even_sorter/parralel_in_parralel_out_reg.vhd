library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity ParallelInParallelOutRegister is
    Port (
        clk : in STD_LOGIC;          -- Clock input
        reset : in STD_LOGIC;        -- Reset input
        enable : in STD_LOGIC;       -- Enable input
        data_in : in STD_LOGIC_VECTOR(7 downto 0);    -- Data input
        parallel_out : out STD_LOGIC_VECTOR(7 downto 0)  -- Parallel output
    );
end ParallelInParallelOutRegister;


architecture Behavioral of ParallelInParallelOutRegister is
    signal reg_data : STD_LOGIC_VECTOR(7 downto 0);  -- Internal register signal
begin

    -- Register logic process
    process(clk, reset)
    begin
        if reset = '1' then
            reg_data <= (others => '0');  -- Reset the register to 0
        elsif rising_edge(clk) then
            if enable = '1' then
                reg_data <= data_in;  -- Load data into the register on rising edge of clock when enabled
            end if;
        end if;
    end process;

    -- Parallel output assignment
    parallel_out <= reg_data;

end Behavioral;