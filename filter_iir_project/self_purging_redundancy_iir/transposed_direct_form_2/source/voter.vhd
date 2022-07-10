----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2022 09:50:25 AM
-- Design Name: 
-- Module Name: voter - Behavioral
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
use work.arrays_package.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity voter is
    generic (data_width : natural := 32;
             no_of_modules : natural := 7);
    Port ( voter_i : in array_type (no_of_modules-1 downto 0);
           voter_o : out std_logic_vector(data_width-1 downto 0));
end voter;

architecture Behavioral of voter is
    signal voter_s : std_logic_vector(data_width-1 downto 0):=(others=>'0');
begin
     --redundancy of 1
     --voter_o <= voter_i(0);
     
     --redundancy of 3
--     voter_o <= (voter_i(0) and voter_i(1)) or (voter_i(0) and voter_i(2)) or (voter_i(1) and voter_i(2));
     
     --redundancy of 5
     voter_o <= (voter_i(0) and voter_i(1)) or (voter_i(0) and voter_i(2)) or (voter_i(0) and voter_i(3)) or (voter_i(0) and voter_i(4))
                  or (voter_i(1) and voter_i(2)) or (voter_i(1) and voter_i(3)) or (voter_i(1) and voter_i(4))
                  or (voter_i(2) and voter_i(3)) or (voter_i(2) and voter_i(4)) or (voter_i(3) and voter_i(4));
                  
     --redundancy of 7
--      voter_o <= (voter_i(0) and voter_i(1)) or (voter_i(0) and voter_i(2)) or (voter_i(0) and voter_i(3)) 
--                  or (voter_i(0) and voter_i(4)) or (voter_i(0) and voter_i(5)) or (voter_i(0) and voter_i(6))
--                  or (voter_i(1) and voter_i(2)) or (voter_i(1) and voter_i(3)) or (voter_i(1) and voter_i(4))
--                  or (voter_i(1) and voter_i(5)) or (voter_i(1) and voter_i(6)) or (voter_i(2) and voter_i(3))
--                  or (voter_i(2) and voter_i(4)) or (voter_i(2) and voter_i(5)) or (voter_i(2) and voter_i(6))
--                  or (voter_i(3) and voter_i(4)) or (voter_i(3) and voter_i(5)) or (voter_i(3) and voter_i(6))
--                  or (voter_i(4) and voter_i(5)) or (voter_i(4) and voter_i(6)) or (voter_i(5) and voter_i(6));

end Behavioral;
