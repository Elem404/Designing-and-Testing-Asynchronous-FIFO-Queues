library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wr_ctrl is
  generic (
    g_ADDR_WIDTH : positive := 4
  );
  port (
    i_CLK         : in  std_logic;
    i_RST         : in  std_logic;
    i_INC         : in  std_logic;
    i_SYNC_RD_PTR : in  std_logic_vector(g_ADDR_WIDTH downto 0);
    o_FULL_FLAG   : out std_logic;
    o_WR_ADDR     : out std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    o_WR_PTR      : out std_logic_vector(g_ADDR_WIDTH downto 0)
  );
end entity;
--Signal decleration
--s for connect signal and r for reg
architecture RTL of wr_ctrl is
	
  signal r_binary_addr : unsigned(g_ADDR_WIDTH downto 0) := (others => '0'); 
  signal s_bin_next    : unsigned(g_ADDR_WIDTH downto 0) := (others => '0');
  signal s_gray_next   : std_logic_vector(g_ADDR_WIDTH downto 0) := (others => '0');
  signal r_full, s_full_val  : std_logic := '0';
  signal cycle_count  : integer :=0; 
begin

	--pointer register for binary address, used for memory accesing
  bin_reg : process(i_CLK, i_RST)
  
  begin
    if i_RST = '1' then
      r_binary_addr <= (others => '0'); 
      cycle_count <=0;
    elsif rising_edge(i_CLK) then
      cycle_count <=cycle_count +1;
      r_binary_addr <= s_bin_next;
    end if;
  end process;

	--pointer register for write ptr

  ptr_reg : process(i_CLK, i_RST)
  begin
    if i_RST = '1' then
      o_WR_PTR <= (others => '0');
   
    elsif rising_edge(i_CLK) then
      o_WR_PTR <= s_gray_next;
    end if;
  end process;
  --comented code was used to test bypassing of the fifo controller to simulate metastabillity
  
  
  --
  --ptr_reg : process(i_CLK, i_RST)
  --begin
  --  if i_RST = '1' then
  --    -- Reset condition: reset the counter and `o_WR_PTR`
  --    o_WR_PTR <= (others => '0');
  --    cycle_count <= 0;  -- Reset counter
  --  elsif rising_edge(i_CLK) then
  --    -- Increment the cycle count
  --    cycle_count <= cycle_count + 1;
--
  --    -- If it's the fourth clock cycle, set `o_WR_PTR` to a specific value
  --    if cycle_count = 4 then
  --      o_WR_PTR <= "0XXXX";
  --    elsif cycle_count = 5 then
  --      o_WR_PTR <= "0XXXX";
  --    elsif cycle_count = 6 then
  --      o_WR_PTR <= "0XXXX";
  --    else
  --      -- Otherwise, use the existing logic
  --      o_WR_PTR <= s_gray_next;
  --    end if;
  --  end if;
  --end process;

--full flag flip flop internal
  full_flag : process(i_CLK, i_RST)
  begin
    if i_RST = '1' then
      r_full <= '0';
    elsif rising_edge(i_CLK) then
      r_full <= s_full_val;
    end if;
  end process;
  o_FULL_FLAG <= r_full;

--use binary address to point to dual port memory
o_WR_ADDR <= std_logic_vector(r_binary_addr(g_ADDR_WIDTH-1 downto 0));
--process (i_CLK)
--    begin
--  
--if cycle_count = 4 then
--        -- Set o_WR_ADDR to "111" after 5 clock cycles
--  o_WR_ADDR <= "1X01";
--else
--        -- Default behavior for o_WR_ADDR
--  o_WR_ADDR <= std_logic_vector(r_binary_addr(g_ADDR_WIDTH-1 downto 0));
--end if;
--end process;



s_bin_next  <= r_binary_addr + 1 when ((i_INC and (not r_full)) = '1') else r_binary_addr;
-- gray code conversion of address to output to read controller
s_gray_next <= std_logic_vector(shift_right(s_bin_next, 1)) xor std_logic_vector(s_bin_next);

--std_logic_vector(s_bin_next);
--process (i_CLK)
--	begin
--
--        if cycle_count = 5 then
--
--			s_gray_next <= "001X1";
--        else
--        	s_bin_next  <= r_binary_addr + 1 when ((i_INC and (not r_full)) = '1') else r_binary_addr;
--			s_gray_next <= std_logic_vector(shift_right(s_bin_next, 1)) xor std_logic_vector(s_bin_next);
--        end if;
--end process;




--full flag
s_full_val  <=  '1' when  (((s_gray_next(g_ADDR_WIDTH) ) /= (i_SYNC_RD_PTR(g_ADDR_WIDTH))) and
                          ((s_gray_next(g_ADDR_WIDTH-1)) /= (i_SYNC_RD_PTR(g_ADDR_WIDTH-1))) and
                          ((s_gray_next(g_ADDR_WIDTH-2 downto 0)) = (i_SYNC_RD_PTR(g_ADDR_WIDTH-2 downto 0))))
                    else '0';


end architecture;