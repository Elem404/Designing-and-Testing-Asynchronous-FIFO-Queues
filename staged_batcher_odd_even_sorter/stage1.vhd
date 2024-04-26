library ieee;
use ieee.std_logic_1164.all;
-- Combinational circuit built of 4 comperators working concurrently
entity stageOne is
    Port (
		Input : in std_logic_vector(7 downto 0);
        Output : out std_logic_vector(7 downto 0);
    );
end stageOne;

architecture Behavioral of stageOne is
 component comperator
        Port (
            A, B : in  std_logic;
            Max, Min : out std_logic;
        );
    end component;
begin
    Comperator_1 : comperator
        port map (
            A => Input(0),
            B => Input(1),
            Max => Output(0),
            Min => Output(1)
        );

    Comperator_2 : comperator
        port map (
            A => Input(2),
            B => Input(3),
            Max => Output(2),
            Min => Output(3)
        );

    Comperator_3 : comperator
        port map (
            A => Input(4),
            B => Input(5),
            Max => Output(4),
            Min => Output(5)
        );

    Comperator_4 : comperator
        port map (
            A => Input(6),
            B => Input(7),
            Max => Output(6),
            Min => Output(7)
        );
end Behavioral;
