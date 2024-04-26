library ieee;
use ieee.std_logic_1164.all;
-- Combinational circuit built of 2 comperators working concurrently
entity stageFive is
    Port (
        Input : in std_logic_vector(7 downto 0);
        Output : out std_logic_vector(7 downto 0);
    );
end stageFive;

architecture Behavioral of stageFive is
    component comperator
        Port (
            A, B : in std_logic;
            Max, Min : out std_logic;
        );
    end component;

begin
    -- Comperators connecting Input(2) and Input(4) to Output(2) and Output(4)
    Comperator_1 : comperator
        port map (
            A => Input(2),
            B => Input(4),
            Max => Output(2),
            Min => Output(4)
        );

    Comperator_2 : comperator
        port map (
            A => Input(3),
            B => Input(5),
            Max => Output(3),
            Min => Output(5)
        );

    -- Direct connections for all other input-output bits
    Output(0) <= Input(0);  -- Connect bit 0 from input to output
    Output(1) <= Input(1);  -- Connect bit 1 from input to output
 
    Output(6) <= Input(6);  -- Connect bit 6 from input to output
    Output(7) <= Input(7);  -- Connect bit 7 from input to output

end Behavioral;
