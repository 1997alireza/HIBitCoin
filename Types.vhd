library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package sha_types is
    type STATE_TYPE is (PADDING, BLOCK_PROCESS, HASH_PROCESS);  
    type SectionType is array( 63 downto 0 ) of std_logic_vector( 31 downto 0 );
end sha_types;

package body sha_types is

end package body;