
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_testb is
--  Port ( );
end cpu_testb;

architecture Behavioral of cpu_testb is
    signal clk :  std_logic := '1';
    signal ALUSEL :  std_logic;
    --signal ALUOUT :  std_logic_vector(7 downto 0);
    signal ACLOAD :  std_logic;
    signal LOAD_AC :  std_logic_vector(7 downto 0);
    signal ACINC :  std_logic;
    signal ACOUT :  std_logic_vector(7 downto 0);
    signal LOAD_AR :  std_logic_vector(5 downto 0);
    signal ARLOAD :  std_logic;
    signal AROUT :  std_logic_vector(5 downto 0);
    signal LOAD_DR :  std_logic_vector(7 downto 0);
    signal DRLOAD :  std_logic;
    signal DROUT :  std_logic_vector(7 downto 0);
    signal LOAD_IR :  std_logic_vector(1 downto 0);
    signal IRLOAD :  std_logic;
    signal IROUT :  std_logic_vector(1 downto 0);
    signal LOAD_PC :  std_logic_vector(5 downto 0);
    signal PCLOAD :  std_logic;
    signal PCINC :  std_logic;
    signal PCOUT :  std_logic_vector(5 downto 0);
    signal op1 :  std_logic_vector(7 downto 0);
    signal op2 :  std_logic_vector(7 downto 0);
    signal res :  std_logic_vector(7 downto 0);
    signal addr :  std_logic_vector(5 downto 0);
    signal read :  std_logic;
    signal data :  std_logic_vector(7 downto 0);

begin

rom_instance : entity work.rom port map(
    clk => clk, 
    read => read, 
    addr => addr, 
    data => data
);

alu_instance : entity work.ALU port map(
ALUSEl => ALUSEL, 
op1 => op1,
op2 => op2,
res => res,
clk => clk
);

ac_instance : entity work.accumulator port map(
clk => clk, 
LD => ACLOAD,
LOAD => LOAD_AC,
ACOUT => ACOUT,
INC => ACINC
);

ar_instance : entity work.address_register port map(
clk => clk, 
LD => ARLOAD,
LOAD => LOAD_AR,
AROUT => AROUT
);

dr_instance : entity work.data_register port map(
clk => clk,
LD => DRLOAD,
LOAD => LOAD_DR,
DROUT => DROUT
);

ir_instance : entity work.instruction_register port map(
clk => clk, 
LD => IRLOAD,
LOAD => LOAD_IR,
IROUT => IROUT
);

pc_instance : entity work.program_counter port map(
clk => clk,
LD => PCLOAD,
INC => PCINC,
LOAD => LOAD_PC,
PCOUT => PCOUT
);

cu_instance : entity work.unidad_c port map(
clk => clk,
ALUSEL => ALUSEL,
ACLOAD => ACLOAD,
LOAD_AC => LOAD_AC,
ACINC => ACINC,
ACOUT => ACOUT,

LOAD_AR => LOAD_AR,
ARLOAD => ARLOAD,
AROUT => AROUT,

LOAD_DR => LOAD_DR,
DRLOAD => DRLOAD,
DROUT => DROUT,

LOAD_IR => LOAD_IR,
IRLOAD => IRLOAD,
IROUT => IROUT,

LOAD_PC => LOAD_PC,
PCLOAD => PCLOAD,
PCINC => PCINC,
PCOUT => PCOUT,

op1 => op1, 
op2 => op2,
res => res,

addr => addr,
read => read,
data => data
);



process
begin
    while true loop
        clk <= not clk;
        wait for 10 ns;
    end loop;
end process;


end Behavioral;