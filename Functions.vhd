library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.sha_types.all;
use ieee.numeric_std.all;

package sha_functions is
    function padded_msg_size(msg_size : in integer) return integer;
    function padding(msg : STD_LOGIC_VECTOR; padding_msg_size : integer) return STD_LOGIC_VECTOR;
    function sigma_one ( x : std_logic_vector ) return std_logic_vector;
    function sigma_zero ( x : std_logic_vector ) return std_logic_vector;
    function permutation ( x : std_logic_vector ) return std_logic_vector;
end sha_functions;

package body sha_functions is
   function padded_msg_size(msg_size : in integer) return integer is
       variable last_part, ret : integer;
   begin
      last_part := (msg_size+1) mod 512;
      ret := 448 - last_part + 1 + msg_size;
      if (last_part > 448) then
         ret := 512 + ret;
      end if;
      ret:= 512;
      return ret;
   end;
   
   function padding(msg : STD_LOGIC_VECTOR; padding_msg_size : integer) return STD_LOGIC_VECTOR is
      variable padding_msg : STD_LOGIC_VECTOR(padding_msg_size-1 downto 0);
   begin
      padding_msg(msg'length-1 downto 0) := msg(msg'length-1 downto 0);
      padding_msg(msg'length) := '1';
      padding_msg(padding_msg_size-1 downto msg'length+1) := (others => '0');
      return padding_msg;
   end;
   
   function sigma_zero( x : std_logic_vector ) return std_logic_vector is
    begin
        return std_logic_vector( rotate_right( unsigned ( x ), 17 ) xor rotate_right( unsigned ( x ), 14 ) xor shift_right( unsigned ( x ), 12 ) );
    end function;

    function sigma_one( x : std_logic_vector ) return std_logic_vector is
    begin
        return std_logic_vector( rotate_right( unsigned ( x ), 9 ) xor rotate_right( unsigned ( x ), 19 ) xor shift_right( unsigned ( x ), 9 ) );
    end function;
    
    function permutation( x : std_logic_vector ) return std_logic_vector is
        variable padding_msg,result : STD_LOGIC_VECTOR(31 downto 0);
        begin
            result(31) := x(0);result(30) := x(1);result(29) := x(2);result(28) := x(3);result(27) := x(4);
            result(26) := x(5);result(25) := x(6);result(24) := x(7);result(23) := x(15);result(22) := x(14);
            result(21) := x(13);result(20) := x(12);result(19) := x(11);result(18) := x(10);result(17) := x(9);
            result(16) := x(8);result(15) := x(16);result(14) := x(17);result(13) := x(18);result(12) := x(19);
            result(11) := x(20);result(10) := x(21);result(9) := x(22);result(8) := x(23);result(7) := x(24);
            result(6) := x(25);result(5) := x(26);result(4) := x(27);result(3) := x(28);result(2) := x(29);
            result(1) := x(30);result(0) := x(31);
            return result;
        end function;
    

    procedure ready_hash ( signal a, b, c, d, e, f, g, h : inout std_logic_vector( 31 downto 0 ); signal Hash : in std_logic_vector( 255 downto 0 ) ) is
    begin
      a <= Hash( 31 downto 0 );
      b <= Hash( 63 downto 32 );
      c <= Hash( 95 downto 64 );
      d <= Hash( 127 downto 96 );
      e <= Hash( 159 downto 128 ); 
      f <= Hash( 191 downto 160 );
      g <= Hash( 223 downto 192 );
      h_reg <= Hash( 255 downto 224 );
end procedure;
      
end package body;