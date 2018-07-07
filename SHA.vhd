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

architecture rtl of SHA is
    signal State : STATE_TYPE;
    signal padding_msg : STD_LOGIC_VECTOR(natural(padded_msg_size(msg_length)-1) downto 0);		
    signal a : integer;	   
    signal W : SectionType;
    signal a, b, c, d, e, f, g, h : std_logic_vector( 31 downto 0 );
    signal Hashes : std_logic_vector( 255 downto 0 ) := ( others => '0' );
begin 
  process (clock, reset)
  variable block_section : integer := 0;
  variable i : integer := 0;
  begin 
    if (reset = '1') then
	   State <= PADDING;
    elsif rising_edge(clock) then   
        case State is
            when PADDING =>
                padding_msg <= padding(msg, padded_msg_size(msg_length));
                State <= BLOCK_PROCESS; 
            when BLOCK_PROCESS => 
                if (block_section >=0 and block_section <= 15) then
                    W( block_section ) <= permutation(padding_msg ( ((i)*512 + ( ( 32 * ( block_section + 1 ) ) - 1 )) downto ((i)*512 + ( 32*block_section )) ));
                elsif (block_section >= 16 and block_section <= 63) then
                    W( block_section ) <= permutation(std_logic_vector( unsigned( sigma_one ( W( block_section - 1 ) ) ) + unsigned ( W ( block_section - 6 ) ) + unsigned ( sigma_zero( W( block_section - 12 ) ) ) + unsigned ( W ( block_section - 15 ) ) ));
                else 
                    ready_hash(a,b,c,d,e,f,g,h,Hashes)
                    State <= HASH_PROCESS;
                end if;
                block_section := block_section + 1;
            when HASH_PROCESS => 
                
            when others =>
                State <= PADDING;
        end case; 
    end if; 
  end process;
end rtl;