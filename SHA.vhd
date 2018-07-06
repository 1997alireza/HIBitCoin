library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sha_types.all;
use work.sha_functions.all;

entity SHA is
generic (msg_length : integer := 4 );
port (clock:    in STD_LOGIC;
      P:        in STD_LOGIC;
      reset:    in STD_LOGIC;
      msg:      in STD_LOGIC_VECTOR(msg_length-1 downto 0);
      hash : out STD_LOGIC_VECTOR(255 downto 0));
end entity;

architecture RTL of SHA is
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
                
            when others =>
                State <= PADDING;
        end case; 
    end if; 
  end process;
end rtl;