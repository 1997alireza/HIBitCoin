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
    signal padding_msg : STD_LOGIC_VECTOR(natural(padded_msg_size(msg_length)-1) downto 0);		   
begin 
  process (clock, reset)
    variable hash_iteration : integer := 0;
    variable a, b, c, d, e, f, g, h : std_logic_vector(31 downto 0); 
  begin 
    if (reset = '1') then            
	   State <= PADDING;
    elsif rising_edge(clock) then   
        case State is
            when PADDING =>
                padding_msg <= padding(msg, padded_msg_size(msg_length));
                State <= BLOCK_PROCESS; 
            when BLOCK_PROCESS => 
                if P='1' then 
                    hash_iteration := 0;
                    State <= HASH_PROCESS; 
                end if; 
            when HASH_PROCESS => 
                if hash_iteration < 64 then
                    
                else
                
                end if;
            when others =>
                State <= PADDING;
        end case; 
    end if; 
  end process;
end rtl;