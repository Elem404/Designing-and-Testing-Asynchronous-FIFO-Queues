library ieee;
use ieee.std_logic_1164.all;
-- Combinational circuit built of 2 comperators working concurrently
entity stageFour is
    Port (
        Input : in std_logic_vector(7 downto 0);
        Output : out std_logic_vector(7 downto 0);
    );
end stageFour;

architecture Behavioral of stageFour is
    component comperator
        Port (
            A, B : in  std_logic;
            Max, Min : out std_logic;
        );
    end component;

begin
    -- Comperator connections
    Comperator_1 : comperator
        port map (
            A => Input(1),
            B => Input(5),
            Max => Output(1),
            Min => Output(5)
        );

    Comperator_2 : comperator
        port map (
            A => Input(2),
            B => Input(6),
            Max => Output(2),
            Min => Output(6)
        );

    -- Direct connections for all other input-output bits
    Output(0) <= Input(0);  -- Connect bit 0 from input to output
    Output(3) <= Input(3);  -- Connect bit 3 from input to output
    Output(4) <= Input(4);  -- Connect bit 4 from input to output
    Output(7) <= Input(7);  -- Connect bit 7 from input to output

end Behavioral;
