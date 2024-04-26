library ieee;
use ieee.std_logic_1164.all;

entity fullDesign_pipeline_v1 is
    Port (
    	clk : in STD_LOGIC;
    	reset : in STD_LOGIC;        -- Reset input
        enable : in STD_LOGIC;
        -- External input for the first stage
        ExtInput : in std_logic_vector(7 downto 0);
        -- External output for the last stage
        ExtOutput : out std_logic_vector(7 downto 0);
    );
end fullDesign_pipeline_v1;

architecture Behavioral of fullDesign_pipeline_v1 is
    -- Declare signals to connect the stages
signal reg1_out, reg2_out, reg3_out, reg4_out, reg5_out,reg6_out : std_logic_vector(7 downto 0);
signal reg1_in, reg2_in, reg3_in, reg4_in, reg5_in,reg6_in : std_logic_vector(7 downto 0);
	component ParallelInParallelOutRegister is
    	Port (
        clk : in STD_LOGIC;          -- Clock input
        reset : in STD_LOGIC;        -- Reset input
        enable : in STD_LOGIC;       -- Enable input
        data_in : in STD_LOGIC_VECTOR(7 downto 0);    -- Data input
        parallel_out : out STD_LOGIC_VECTOR(7 downto 0);  -- Parallel output
    );
    end component;
    
    -- Declare the six stages as components
    component stageOne
        Port (
            Input : in std_logic_vector(7 downto 0);
            Output : out std_logic_vector(7 downto 0);
        );
    end component;

    component stageTwo
        Port (
            Input : in std_logic_vector(7 downto 0);
            Output : out std_logic_vector(7 downto 0);
        );
    end component;

    component stageThree
        Port (
            Input : in std_logic_vector(7 downto 0);
            Output : out std_logic_vector(7 downto 0);
        );
    end component;

    component stageFour
        Port (
            Input : in std_logic_vector(7 downto 0);
            Output : out std_logic_vector(7 downto 0);
        );
    end component;

    component stageFive
        Port (
            Input : in std_logic_vector(7 downto 0);
            Output : out std_logic_vector(7 downto 0);
        );
    end component;

    component stageSix
        Port (
            Input : in std_logic_vector(7 downto 0);
            Output : out std_logic_vector(7 downto 0);
        );
    end component;

begin
    -- Register between input and stage 1
    reg1 : ParallelInParallelOutRegister
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => ExtInput,
            parallel_out => reg1_out
        );

    -- Connect stage 1
    stage1 : stageOne
        port map (
            Input => reg1_out,
            Output => reg2_in
        );

    -- Register between stage 1 and stage 2
    reg2 : ParallelInParallelOutRegister
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => reg2_in,
            parallel_out => reg2_out
        );

    -- Connect stage 2
    stage2 : stageTwo
        port map (
            Input => reg2_out,
            Output => reg3_in
        );

    -- Register between stage 2 and stage 3
    reg3 : ParallelInParallelOutRegister
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => reg3_in,
            parallel_out => reg3_out
        );

    -- Connect stage 3
    stage3 : stageThree
        port map (
            Input => reg3_out,
            Output => reg4_in
        );

    -- Register between stage 3 and stage 4
    reg4 : ParallelInParallelOutRegister
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => reg4_in,
            parallel_out => reg4_out
        );

    -- Connect stage 4
    stage4 : stageFour
        port map (
            Input => reg4_out,
            Output => reg5_in
        );

    -- Register between stage 4 and stage 5
    reg5 : ParallelInParallelOutRegister
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => reg5_in,
            parallel_out => reg5_out
        );

    -- Connect stage 5
    stage5 : stageFive
        port map (
            Input => reg5_out,
            Output => reg6_in
        );
    reg6 : ParallelInParallelOutRegister
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            data_in => reg6_in,
            parallel_out => reg6_out
        );

    -- Register between stage 5 and stage 6
    stage6 : stageSix
        port map (
            Input => reg6_out,
            Output => ExtOutput
        );

end Behavioral;