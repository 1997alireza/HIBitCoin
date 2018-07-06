library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.sha_types.all;

package sha_functions is
    function padded_msg_size(msg_size : in integer) return integer;
    function padding(msg : STD_LOGIC_VECTOR; padding_msg_size : integer) return STD_LOGIC_VECTOR;
    function inner_compression(a,b,c,d,e,f,g,h,kt,wt : STD_LOGIC_VECTOR(31 downto 0)) return LOGIC_VECTOR_8_32;
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
      
   function inner_compression(a,b,c,d,e,f,g,h,kt,wt : STD_LOGIC_VECTOR(31 downto 0)) return LOGIC_VECTOR_8_32;
      variable big_sigma1, chEFG, t2, big_sigma0, majABC, cPlusD, big_sigma2, t1 : STD_LOGIC_VECTOR (31 downto 0); 
   begin
   
   end;
      
end package body;