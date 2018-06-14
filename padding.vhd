----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/14/2018 09:37:01 PM
-- Design Name: 
-- Module Name: padding - Behavioral
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

entity padding is
    generic ( msg_size : integer := 4);
    Port ( msg : in STD_LOGIC_VECTOR (msg_size downto 0);
           padding_msg : out STD_LOGIC_VECTOR (0 downto 0));
end padding;

architecture Behavioral of padding is

begin


end Behavioral;
