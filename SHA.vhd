library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY SimpleFSM is
generic ( msg_length : integer := 4 );
PORT (clock:    IN STD_LOGIC;
      P:        IN STD_LOGIC;
      reset:    IN STD_LOGIC;
      msg:      IN STD_LOGIC_VECTOR(msg_length-1 downto 0);
      hash : out STD_LOGIC_VECTOR(255 downto 0)
END SimpleFSM;

Architecture RTL of SimpleFSM is
TYPE State_type IS (PADDING, BLOCK_PROCESS, HASH_PROCESS);  
    SIGNAL State : State_Type;
    signal W : SectionType;
							     
BEGIN 
  PROCESS (clock, reset) 
  variable block_section : integer := 0;
  BEGIN 
    If (reset = '1') THEN            
	   State <= PADDING;
 
    ELSIF rising_edge(clock) THEN   
        CASE State IS
     
            WHEN PADDING => 
                IF P='1' THEN 
                    State <= BLOCK_PROCESS; 
                END IF; 
     
            WHEN BLOCK_PROCESS => 
                if (block_section >=0 and block_section <= 15) then
                    W( 15 - t ) <= M ( i ) ( ( ( 32*( t + 1 ) ) - 1 ) downto ( 32*t ) );
                end if;
                IF P='1' THEN 
                    State <= HASH_PROCESS;
                END IF; 
            WHEN HASH_PROCESS => 
                IF P='1' THEN 
                    State <= D; 
                END IF; 
            WHEN others =>
                State <= PADDING;
        END CASE; 
    END IF; 
  END PROCESS;


END rtl;