library ieee;
use ieee.std_logic_1164.all;
-- Combinational circuit built of 3 comperators working concurrently
entity stageSix is
    Port (
		Input : in std_logic_vector(7 downto 0);
        Output : out std_logic_vector(7 downto 0);
    );
end stageSix;

architecture Behavioral of stageSix is
 component comperator
        Port (
            A, B : in  std_logic;
            Max, Min : out std_logic;
        );
    end component;
begin
    Comperator_1 : comperator
        port map (
            A => Input(1),
            B => Input(2),
            Max => Output(1),
            Min => Output(2)
        );

    Comperator_2 : comperator
        port map (
            A => Input(3),
            B => Input(4),
            Max => Output(3),
            Min => Output(4)
        );

    Comperator_3 : comperator
        port map (
            A => Input(5),
            B => Input(6),
            Max => Output(5),
            Min => Output(6)
        );
        Output(0) <= Input(0);
        Output(7) <= Input(7);

end Behavioral;
