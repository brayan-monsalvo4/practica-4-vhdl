library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity unidad_c is
Port ( 
    clk : in std_logic;
    
    ALUSEL : out std_logic;
    --ALUOUT : in std_logic_vector(7 downto 0);
    
    --Accumulator
    ACLOAD : out std_logic;
    LOAD_AC : out std_logic_vector(7 downto 0);
    ACINC : out std_logic;
    ACOUT : in std_logic_vector(7 downto 0);
    
    --Address Register
    LOAD_AR : out std_logic_vector(5 downto 0);
    ARLOAD : out std_logic;
    AROUT : in std_logic_vector(5 downto 0);
    
    --Data Register
    LOAD_DR : out std_logic_vector(7 downto 0);
    DRLOAD : out std_logic;
    DROUT : in std_logic_vector(7 downto 0);
    
    --Instruction Register
    LOAD_IR : out std_logic_vector(1 downto 0);
    IRLOAD : out std_logic;
    IROUT : in std_logic_vector(1 downto 0);
    
    --Program Counter
    LOAD_PC : out std_logic_vector(5 downto 0);
    PCLOAD : out std_logic;
    PCINC : out std_logic;
    PCOUT : in std_logic_vector(5 downto 0);
    
    --ALU
    op1 : out std_logic_vector(7 downto 0);
    op2 : out std_logic_vector(7 downto 0);
    res : in std_logic_vector(7 downto 0);
    
    --ROM
    addr : out std_logic_vector(5 downto 0);
    read : out std_logic;
    data : in std_logic_vector(7 downto 0)
    
);
end unidad_c;

architecture Behavioral of unidad_c is
type estados is (fetch1, fetch2, fetch3, add1, and1, jmp1, inc1);
signal estado_actual : estados := fetch1;
signal add1_aux : integer := 0;
signal and1_aux : integer := 0;

begin

process(clk)
begin
if (rising_edge(clk)) then
    case estado_actual is
        when fetch1 =>
            LOAD_AR <= PCOUT;
            
            estado_actual <= fetch2;
        when fetch2 =>
            addr <= AROUT;
            LOAD_DR <= data;
            
            estado_actual <= fetch3;
         when fetch3 =>
            LOAD_IR <= DROUT(1 downto 0);
            
            LOAD_AR <= DROUT(7 downto 2);
            
            case DROUT(1 downto 0) is
                when "00" =>
                    estado_actual <= add1;
                when "01" => 
                    estado_actual <= and1;
                when "10" =>
                    estado_actual <= jmp1;
                when "11" =>
                    estado_actual <= inc1;
                when others =>
                    estado_actual <= fetch1;
            end case;   
            
         when add1 => 
            op1 <= ACOUT;
            op2 <= ("00" & AROUT);
            
            LOAD_AC <= res;
            
            estado_actual <= fetch1;
        
        when and1 =>
            op1 <= ACOUT;
            op2 <= ("00" & AROUT);
            
            LOAD_AC <= res;
            
            estado_actual <= fetch1;
        
        when jmp1 =>
            LOAD_PC <= DROUT(7 downto 2);
            
            estado_actual <= fetch1;
            
        when inc1 =>
            estado_actual <= fetch1;
        
    end case;
            
end if;
end process;

process(estado_actual)
begin
case estado_actual is
    when fetch1 =>
        ARLOAD <= '1';
        
        PCLOAD <= '0';
        PCINC <= '0';
        DRLOAD <= '0';
        ACLOAD <= '0';
        ACINC <= '0';
        IRLOAD <= '0';
        read <= '0';
    when fetch2 =>
        PCINC <= '1';
        DRLOAD <= '1';
        read <= '1';

        ARLOAD <= '0';
        PCLOAD <= '0';
        ACLOAD <= '0';
        ACINC <= '0';
        IRLOAD <= '0';
        
    when fetch3 =>
        ACLOAD <= '1';
        IRLOAD <= '1';

        PCINC <= '0';
        DRLOAD <= '0';
        read <= '0';
        ARLOAD <= '0';
        PCLOAD <= '0';
        ACINC <= '0';
        
    when add1 =>
        ACLOAD <= '1';
        IRLOAD <= '0';

        ALUSEL <= '0';
        
        PCINC <= '0';
        DRLOAD <= '0';
        read <= '0';
        ARLOAD <= '0';
        PCLOAD <= '0';
        ACINC <= '0';
        
    when and1 =>
        ACLOAD <= '1';
        IRLOAD <= '0';

        ALUSEL <= '1';
        
        PCINC <= '0';
        DRLOAD <= '0';
        read <= '0';
        ARLOAD <= '0';
        PCLOAD <= '0';
        ACINC <= '0';
        
    when jmp1 =>
        PCLOAD <= '1';

        ACLOAD <= '0';
        ALUSEL <= '0';
        PCINC <= '0';
        DRLOAD <= '0';
        read <= '0';
        ARLOAD <= '0';
        ACINC <= '0';
     
     when inc1 =>
        ACINC <= '1';

        PCLOAD <= '0';
        ACLOAD <= '0';
        ALUSEL <= '0';
        PCINC <= '0';
        DRLOAD <= '0';
        read <= '0';
        ARLOAD <= '0';
            
    when others =>
        ACINC <= '0';

        PCLOAD <= '0';
        ACLOAD <= '0';
        ALUSEL <= '0';
        PCINC <= '0';
        DRLOAD <= '0';
        ARLOAD <= '0';
                    
            
end case;
end process;

end Behavioral;
