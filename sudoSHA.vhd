library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sha_types.all;
use work.sha_functions.all;

entity sudoSHA is
generic (msg_length : integer := 32);
port (clock:    in STD_LOGIC;
      reset:    in STD_LOGIC;
      msg:      in STD_LOGIC_VECTOR(msg_length-1 downto 0);
      ready:    out STD_LOGIC;
      out_hash :    out STD_LOGIC_VECTOR(255 downto 0));
end entity;

architecture rtl of sudoSHA is
    component SHA is
    generic (msg_length : integer := 32 );
    port (clock:    in STD_LOGIC;
          reset:    in STD_LOGIC;
          msg:      in STD_LOGIC_VECTOR(msg_length-1 downto 0);
          ready:    out STD_LOGIC;
          hash :    out STD_LOGIC_VECTOR(255 downto 0));
    end component;
    
    signal State : SUDO_STATE_TYPE := WAITING;	
    signal market_root_reset, market_root_ready : STD_LOGIC := '0';
    signal markel_root_hash : STD_LOGIC_VECTOR(255 downto 0);
    
    signal temp_hash_reset, temp_hash_ready : STD_LOGIC := '0';
    signal hash_reset, hash_ready : STD_LOGIC := '0';
    signal hash, temp_hash : std_logic_vector(255 downto 0);

    signal block_header : STD_LOGIC_VECTOR (863 downto 0);
    signal nonce : STD_LOGIC_VECTOR (255 downto 0):= (others => '0');
begin 
  markel_root_sha: SHA generic map(msg_length) port map(clock, market_root_reset, msg, market_root_ready, markel_root_hash);
  temp_hash_sha: SHA generic map(864) port map(clock, temp_hash_reset, block_header, temp_hash_ready, temp_hash);
  hash_sha: SHA generic map(256) port map(clock, hash_reset, temp_hash, hash_ready, hash);
  process (clock, reset)
    variable next_nonce : STD_LOGIC_VECTOR (255 downto 0);
  begin
    if (reset = '1') then
	   State <= MARKEL_ROOT_START;
	   ready <= '0';
    elsif rising_edge(clock) then 
        case State is
            when MARKEL_ROOT_START =>
                market_root_reset <= '1';
                State <= MARKEL_ROOT_CHECK;
            when MARKEL_ROOT_CHECK =>
                market_root_reset <= '0';
                if market_root_ready='1' then
                    block_header <= VERSION & PREV_BLOCK & markel_root_hash & TIMESTAMPS & DIFF & nonce;
                    temp_hash_reset <= '1';
                    State <= TEMP_HASH_CHECK;
                else
                    State <= MARKEL_ROOT_CHECK;
                end if;
            when TEMP_HASH_CHECK =>
                temp_hash_reset <= '0';
                if temp_hash_ready='1' then
                    hash_reset <= '1';
                    State <= HASH_CHECK;
                else
                    State <= TEMP_HASH_CHECK;
                end if;
            when HASH_CHECK =>
                hash_reset <= '0';
                if hash_ready='1' then
                    State <= WHILE_CHECK;
                else
                    State <= HASH_CHECK;
                end if;
            when WHILE_CHECK =>
                if hash>TARGET then
                    next_nonce := std_logic_vector(unsigned(nonce) + 1);
                    nonce <= next_nonce;
                    block_header(255 downto 0) <= next_nonce;
                    temp_hash_reset <= '1';
                    State <= TEMP_HASH_CHECK;
                else
                    out_hash <= hash;
                    ready <= '1';
                    State <= WAITING;
                end if;
            when WAITING => -- waiting for new message with reset signal
            when others =>
                State <= WAITING;
         end case;
      end if;
   end process;
end rtl;