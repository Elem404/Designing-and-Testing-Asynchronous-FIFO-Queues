library ieee;
use ieee.std_logic_1164.all;

entity comperator is
    Port (
        A, B : in  std_logic;
        Max, Min : out std_logic
    );
end comperator;
-- Bit
architecture Behavioral of comperator is
begin
    Process(A, B)
    begin
		Max <= (A or B);
        Min <= (A and B);
    end Process;
end Behavioral;
