library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity SHA is
generic (msg_length : integer := 4 );
port (clock:    IN STD_LOGIC;
      P:        IN STD_LOGIC;
      reset:    IN STD_LOGIC;
      msg:      IN STD_LOGIC_VECTOR(msg_length-1 downto 0);
      hash : out STD_LOGIC_VECTOR(255 downto 0))
end entity;

architecture RTL of SHA is
type STATE_TYPE is (PADDING, BLOCK_PROCESS, HASH_PROCESS);  
	signal State : STATE_TYPE;				     
begin 
  process (clock, reset) 
  begin 
    if (reset = '1') then            
	   State <= PADDING;
    elsif rising_edge(clock) then   
        case State is
     
            when PADDING => 
                State <= BLOCK_PROCESS; 
            when BLOCK_PROCESS => 
                if P='1' then 
                    State <= HASH_PROCESS; 
                end if; 
            when HASH_PROCESS => 
                if P='1' then 
                    State <= D; 
                end if; 
            when others =>
                State <= PADDING;
        end case; 
    end if; 
  end process;
end rtl;