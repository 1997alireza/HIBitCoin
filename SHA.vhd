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
    signal W : SectionType;			     
begin 
  process (clock, reset) 
  variable block_section : integer := 0;
  begin 
    if (reset = '1') then            
	   State <= PADDING;
    elsif rising_edge(clock) then   
        case State is
            when PADDING => 
            when BLOCK_PROCESS => 
                if (block_section >=0 and block_section <= 15) then
                    W( block_section ) <= permutation(M ( i ) ( ( ( 32 * ( block_section + 1 ) ) - 1 ) downto ( 32*block_section ) ));
                elsif (block_section >= 16 and block_section <= 63) then
                    W( block_section ) <= permutation(std_logic_vector( unsigned( sigma_one ( W( t - 1 ) ) ) + unsigned ( W ( t - 6 ) ) + unsigned ( sigma_zero( W( t - 12 ) ) ) + unsigned ( W ( t - 15 ) ) ));
                else 
                    State <= BLOCK_PROCESS;
                end if;
                block_section := block_section + 1;
            when HASH_PROCESS => 
                
            when others =>
                State <= PADDING;
        end case; 
    end if; 
  end process;
end rtl;