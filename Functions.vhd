library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.sha_types.all;
use ieee.numeric_std.all;

package sha_functions is
    function padded_msg_size(msg_size : in integer) return integer;
    function padding(msg : STD_LOGIC_VECTOR; padding_msg_size : integer) return STD_LOGIC_VECTOR;
    function inner_compression(a,b,c,d,e,f,g,h,kt,wt : STD_LOGIC_VECTOR(31 downto 0)) return LOGIC_VECTOR_8_32;
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
      return ret;
   end;
   
   function padding(msg : STD_LOGIC_VECTOR; padding_msg_size : integer) return STD_LOGIC_VECTOR is
      variable padding_msg : STD_LOGIC_VECTOR(padding_msg_size-1 downto 0);
   begin
      padding_msg(padding_msg_size-1 downto padding_msg_size-msg'length) := msg;
      padding_msg(padding_msg_size-msg'length-1) := '1';
      padding_msg(padding_msg_size-msg'length-2 downto 0) := (others => '0');
      return padding_msg;
   end;
      
   function inner_compression(a,b,c,d,e,f,g,h,kt,wt : STD_LOGIC_VECTOR(31 downto 0)) return LOGIC_VECTOR_8_32 is
      variable big_sigma1, chEFG, t2, big_sigma0, majABC, cPlusD, big_sigma2, t1 : unsigned(31 downto 0);
      variable aU,bU,cU,dU,eU,fU,gU,hU,ktU,wtU : unsigned(31 downto 0);
      variable result : LOGIC_VECTOR_8_32;
   begin
      aU := unsigned(a);
      bU := unsigned(b);
      cU := unsigned(c);
      dU := unsigned(d);
      eU := unsigned(e);
      fU := unsigned(f);
      gU := unsigned(g);
      hU := unsigned(h);
      ktU := unsigned(kt);
      wtU := unsigned(wt);
      
      big_sigma1 := rotate_right(eU, 6) xor rotate_right(eU, 11) xor rotate_right(eU, 25);
      chEFG := (eU and fU) xor ( (not fU and gU) xor (not eU and gU));
      t2 := hU + big_sigma1 + chEFG + ktU + wtU;
      big_sigma0 := rotate_right(aU, 2) xor rotate_right(aU, 13) xor rotate_right(aU, 22) xor shift_right(aU, 7);
      majABC := (aU and cU) and (aU and bU) and (bU and cU);
      cPlusD := cU + dU;
      big_sigma2 := rotate_right(cPlusD, 2) xor rotate_right(cPlusD, 3) xor rotate_right(cPlusD, 15) xor shift_right(cPlusD, 5);
      t1 := big_sigma0 + majABC + big_sigma2;
      
      hU := gU;
      fU := eU;
      dU := cU;
      bU := aU;
      gU := fU;
      eU := dU + t1;
      cU := bU;
      aU := t1 + t1 + t1 - t2;
      
      result(0) := std_logic_vector(a);
      result(1) := std_logic_vector(b);
      result(2) := std_logic_vector(c);
      result(3) := std_logic_vector(d);
      result(4) := std_logic_vector(e);
      result(5) := std_logic_vector(f);
      result(6) := std_logic_vector(g);
      result(7) := std_logic_vector(h);
      return result;
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
      
end package body;