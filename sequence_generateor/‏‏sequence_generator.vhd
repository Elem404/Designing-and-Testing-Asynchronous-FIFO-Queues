library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- Required for addition on std_logic_vector
use ieee.numeric_std.all;
entity Sequence_Generator_ROM is
    port (
        clk : in std_logic;
        rst : in std_logic;
        full_flag : in std_logic;
        output_sequence : out std_logic_vector(7 downto 0)
    );
end entity Sequence_Generator_ROM;

architecture Behavioral of Sequence_Generator_ROM is
    type rom_type is array (0 to 3) of std_logic_vector(7 downto 0); -- ROM with 4 sequences
    constant rom : rom_type := (
        "00000100",
        "01010111",
        "01100110",
        "01000100"
    ); -- Define the ROM content

    signal pointer : std_logic_vector(1 downto 0); -- Pointer for the ROM
begin
    process (clk, rst)
    begin
    	if full_flag = '1' then
        	pointer<=pointer;
        elsif rst = '1' then
            pointer <= "00"; -- Reset the pointer to the first ROM address
        elsif rising_edge(clk) then -- On clock rise
            if pointer = "11" then
                pointer <= "00"; -- If pointer is at the last ROM address, reset to the first
            else
                pointer <= pointer + 1; -- Increment the pointer on each clock
            end if;
        end if;
    end process;

    output_sequence <= rom(to_integer(unsigned(pointer))); -- Output based on the current ROM address
end architecture Behavioral;
