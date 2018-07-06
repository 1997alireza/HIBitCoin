library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.sha_types.all;

package sha_functions is
    function padded_msg_size(msg_size : in integer) return integer;
    function padding(msg : STD_LOGIC_VECTOR; padding_msg_size : integer) return STD_LOGIC_VECTOR;
    function inner_compression(a,b,c,d,e,f,g,h,kt,wt : in STD_LOGIC_VECTOR(31 downto 0)) return LOGIC_VECTOR_8_32;
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
      
   function inner_compression(variable a,b,c,d,e,f,g,h,kt,wt : in STD_LOGIC_VECTOR(31 downto 0)) return LOGIC_VECTOR_8_32 is
      variable big_sigma1, chEFG, t2, big_sigma0, majABC, cPlusD, big_sigma2, t1 : unsigned;
      variable aU,bU,cU,dU,eU,fU,gU,hU,ktU,wtU : unsigned;
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
      cPlusD := c + d;
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
      
end package body;