library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package sha_functions is

    function sigma_one ( x : std_logic_vector ) return std_logic_vector;
end sha_functions;

package body sha_functions is
    function sigma_zero ( x : std_logic_vector( 31 downto 0 ) ) return std_logic_vector is
    begin
        return std_logic_vector( rotate_right( unsigned ( x ), 17 ) xor rotate_right( unsigned ( x ), 14 ) xor shift_right( unsigned ( x ), 12 ) );
    end function;
    function sigma_one ( x : std_logic_vector( 31 downto 0 ) ) return std_logic_vector is
    begin
        return std_logic_vector( rotate_right( unsigned ( x ), 9 ) xor rotate_right( unsigned ( x ), 19 ) xor shift_right( unsigned ( x ), 9 ) );
    end function;
    function permutation ( x : std_logic_vector( 31 downto 0 ) ) return std_logic_vector is
    begin
        return x(0 to 7) & x(15 downto 8) & x(16 to 23) & x(24 to 31);
    end function;
end package body;