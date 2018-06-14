----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/14/2018 10:49:37 PM
-- Design Name: 
-- Module Name: SHA256 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SHA256 is
    Generic(msg_length : natural := 4);
    Port ( msg : in STD_LOGIC_VECTOR(msg_length-1 downto 0) := "1000";
           hash : out STD_LOGIC_VECTOR (255 downto 0));
end SHA256;

architecture Behavioral of SHA256 is
    function padded_msg_size (
        msg_size : in integer)
        return integer is
        variable last_part, ret : integer;
    begin
        last_part := (msg_size+1) mod 512;
        ret := 448 - last_part + 1 + msg_size;
        if (last_part > 448) then
            ret := 512 + ret;
        end if;
        return integer(ret);
    end;
    
    component padding is
        Port ( msg : in STD_LOGIC_VECTOR (msg'length-1 downto 0);
               padding_msg : out STD_LOGIC_VECTOR (natural(padded_msg_size(msg'length)-1) downto 0));
    end component;
    
    signal padding_msg : STD_LOGIC_VECTOR(natural(padded_msg_size(msg'length)-1) downto 0);
begin
    padding_obj: padding port map(msg, padding_msg);

end Behavioral;
