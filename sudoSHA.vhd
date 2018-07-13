library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sha_types.all;
use work.sha_functions.all;

entity sudoSHA is
generic (msg_length : integer := 32 );
port (clock:    in STD_LOGIC;
      reset:    in STD_LOGIC;
      msg:      in STD_LOGIC_VECTOR(msg_length-1 downto 0);
      ready:    out STD_LOGIC;
      out_hash :    out STD_LOGIC_VECTOR(255 downto 0));
end entity;

architecture rtl of sudoSHA is
    signal hash : std_logic_vector(255 downto 0) := (0 => '1', others => '0') ;
    signal block_header : STD_LOGIC_VECTOR (7 downto 0):= "00000000";
    signal nonce : STD_LOGIC_VECTOR (256 downto 0):= (others => '0');
begin 
    process (clock)
    begin
        if (clock'Event and clock = '1') then
            while (nonce < 15) loop
                block_header <= VERSION + PREV_BLOCK + MERKEL_ROOT + TIMESTAMPS + DIFF + nonce;
                nonce <= nonce + 1;
            end loop;
        end if;
    end process;
end rtl;