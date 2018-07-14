library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sha_types.all;
use work.sha_functions.all;

entity SHA is
generic (msg_length : integer := 32 );
port (clock:    in STD_LOGIC;
      reset:    in STD_LOGIC;
      msg:      in STD_LOGIC_VECTOR(msg_length-1 downto 0);
      ready:    out STD_LOGIC := '0';
      hash :    out STD_LOGIC_VECTOR(255 downto 0));
end entity;

architecture rtl of SHA is
    signal State : STATE_TYPE := WATING;	
    signal padding_msg : STD_LOGIC_VECTOR(natural(padded_msg_size(msg_length) - 1) downto 0);		 
    signal W : SectionType;
    signal hash_part : LOGIC_VECTOR_8_32;
begin 
  process (clock, reset)
    variable hash_iteration, i, block_section : integer := 0;
    variable inner_compression_result : LOGIC_VECTOR_8_32;
    variable a, b, c, d, ee, f, g, h : std_logic_vector(31 downto 0);
  begin
    if (reset = '1') then
	   State <= PADDING;
	   ready <= '0';
	   hash_part(0) <= reverse_any_vector(HASH_INITIAL(0));
       hash_part(1) <= reverse_any_vector(HASH_INITIAL(1));
       hash_part(2) <= reverse_any_vector(HASH_INITIAL(2));
       hash_part(3) <= reverse_any_vector(HASH_INITIAL(3));
       hash_part(4) <= reverse_any_vector(HASH_INITIAL(4));
       hash_part(5) <= reverse_any_vector(HASH_INITIAL(5));
       hash_part(6) <= reverse_any_vector(HASH_INITIAL(6));
       hash_part(7) <= reverse_any_vector(HASH_INITIAL(7));
	   
    elsif rising_edge(clock) then 
        case State is
            when PADDING =>
                padding_msg <= reverse_any_vector(padding(msg, padded_msg_size(msg_length), msg_length));
                State <= BLOCK_PROCESS; 
            when BLOCK_PROCESS => 
                if (block_section >=0 and block_section <= 15) then
                    W( block_section ) <= (padding_msg (((i)*512 + ( ( 32 * ( block_section + 1 ) ) - 1 )) downto ((i)*512 + ( 32*block_section )))) ;
                elsif (block_section >= 16 and block_section <= 63) then
                    W( block_section ) <= reverse_any_vector((std_logic_vector( unsigned( sigma_one ( reverse_any_vector(W( block_section - 1 )) ) ) + unsigned ( reverse_any_vector(W ( block_section - 6 )) ) + unsigned ( sigma_zero( reverse_any_vector(W( block_section - 12 )) ) ) + unsigned ( reverse_any_vector(W ( block_section - 15 )) ) )));
                else 
                    for counter in 0 to 63 loop
                        W( counter ) <= permutation(W( counter ));
                    end loop;
                    hash_iteration := 0;
                    a := hash_part(0);
                    b := hash_part(1);
                    c := hash_part(2);
                    d := hash_part(3);
                    ee := hash_part(4);
                    f := hash_part(5);
                    g := hash_part(6);
                    h := hash_part(7);
                    State <= HASH_PROCESS;
                end if;
                block_section := block_section + 1;
            when HASH_PROCESS =>
                if hash_iteration < 64 then
                    inner_compression_result := inner_compression(a, b, c, d, ee, f, g, h, reverse_any_vector(CONST_K(hash_iteration)), W(hash_iteration));
                    a := inner_compression_result(0);
                    b := inner_compression_result(1);
                    c := inner_compression_result(2);
                    d := inner_compression_result(3);
                    ee := inner_compression_result(4);
                    f := inner_compression_result(5);
                    g := inner_compression_result(6);
                    h := inner_compression_result(7);
                    hash_iteration := hash_iteration + 1;
                else
                    hash_part(0) <= reverse_any_vector(std_logic_vector(unsigned(reverse_any_vector(hash_part(0))) + unsigned(reverse_any_vector(a))));
                    hash_part(1) <= reverse_any_vector(std_logic_vector(unsigned(reverse_any_vector(hash_part(1))) + unsigned(reverse_any_vector(b))));
                    hash_part(2) <= reverse_any_vector(std_logic_vector(unsigned(reverse_any_vector(hash_part(2))) + unsigned(reverse_any_vector(c))));
                    hash_part(3) <= reverse_any_vector(std_logic_vector(unsigned(reverse_any_vector(hash_part(3))) + unsigned(reverse_any_vector(d))));
                    hash_part(4) <= reverse_any_vector(std_logic_vector(unsigned(reverse_any_vector(hash_part(4))) + unsigned(reverse_any_vector(ee))));
                    hash_part(5) <= reverse_any_vector(std_logic_vector(unsigned(reverse_any_vector(hash_part(5))) + unsigned(reverse_any_vector(f))));
                    hash_part(6) <= reverse_any_vector(std_logic_vector(unsigned(reverse_any_vector(hash_part(6))) + unsigned(reverse_any_vector(g))));
                    hash_part(7) <= reverse_any_vector(std_logic_vector(unsigned(reverse_any_vector(hash_part(7))) + unsigned(reverse_any_vector(h))));
                    
                    if i < (padding_msg'length / 512) - 1 then
                        i := i + 1;
                        block_section := 0;
                        State <= BLOCK_PROCESS;
                    else
                        State <= HASH_READY;
                    end if;
                end if;
            when HASH_READY =>
                hash <= reverse_any_vector(hash_part(0)) & reverse_any_vector(hash_part(1)) & reverse_any_vector(hash_part(2)) & reverse_any_vector(hash_part(3)) & reverse_any_vector(hash_part(4)) & reverse_any_vector(hash_part(5)) & reverse_any_vector(hash_part(6)) & reverse_any_vector(hash_part(7));
                ready <= '1';
                State <= WATING;
            when WATING => -- waiting for new message with reset signal
            when others =>
                State <= WATING;
        end case; 
    end if; 
  end process;
end rtl;