library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rd_ctrl is
  generic (
    g_ADDR_WIDTH : positive := 4
  );
  port (
    i_CLK         : in  std_logic;
    i_RST         : in  std_logic;
    i_INC         : in  std_logic;
    i_SYNC_WR_PTR : in  std_logic_vector(g_ADDR_WIDTH downto 0);
    o_EMPTY_FLAG  : out std_logic;
    o_RD_ADDR     : out std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    o_RD_PTR      : out std_logic_vector(g_ADDR_WIDTH downto 0)
  );
end entity;
--Signal decleration
--s for connect signal and r for reg
architecture RTL of rd_ctrl is

  signal r_binary_addr : unsigned(g_ADDR_WIDTH downto 0) := (others => '0'); -- set to (others => '1') if address zero gets skipped
  signal s_bin_next    : unsigned(g_ADDR_WIDTH downto 0) := (others => '0');
  signal s_gray_next   : std_logic_vector(g_ADDR_WIDTH downto 0) := (others => '0');
  signal r_empty, s_empty_val  : std_logic := '1';
  signal cycle_count  : integer :=0; 
begin

--pointer register for binary address, used for memory accesing
    bin_reg : process(i_CLK, i_RST)
    begin
      if i_RST = '1' then
        r_binary_addr <= (others => '0'); 
     	
      elsif rising_edge(i_CLK) then
      	
      
         before : r_binary_addr <= s_bin_next;
      end if;
    end process;

--pointer register for read ptr
    ptr_reg : process(i_CLK, i_RST)
    begin
      if i_RST = '1' then
        o_RD_PTR <= (others => '0');
      elsif rising_edge(i_CLK) then
        o_RD_PTR <= s_gray_next;
        cycle_count <= cycle_count+1;
      end if;
    end process;
    

--empty flag register,
    empty_flag : process(i_CLK, i_RST)
    begin
      if i_RST = '1' then
        r_empty <= '1';
      elsif rising_edge(i_CLK) then
        r_empty <= s_empty_val;
      end if;
    end process;
    o_EMPTY_FLAG <= r_empty;

--use binary address to point to dual port memory
  o_RD_ADDR <= std_logic_vector(r_binary_addr(g_ADDR_WIDTH-1 downto 0));

-- gray code conversion of address to output to write controller
  s_bin_next  <= r_binary_addr + 1 when ((i_INC and (not r_empty)) = '1') else r_binary_addr;
  s_gray_next <=std_logic_vector(shift_right(s_bin_next, 1)) xor std_logic_vector(s_bin_next);--std_logic_vector(s_bin_next); --
	
--this block was used to check metastability

    --process (i_CLK)
	--begin
    --	if cycle_count = 4 then
	--		s_gray_next <= "00X11";
    --    else
    --    	s_bin_next  <= r_binary_addr + 1 when ((i_INC and (not r_empty)) = '1') else r_binary_addr;
	--		s_gray_next <= std_logic_vector(shift_right(s_bin_next, 1)) xor std_logic_vector(s_bin_next);
    --    end if;
	--end process;


--empty flag logic
  s_empty_val  <=  '1'  when s_gray_next = i_SYNC_WR_PTR
                        else '0';


end architecture;