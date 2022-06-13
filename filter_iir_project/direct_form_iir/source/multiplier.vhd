----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2022 11:56:37 AM
-- Design Name: 
-- Module Name: multiplier - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplier is
    generic(data_width : natural := 32);
    Port ( num1_i : in std_logic_vector(data_width-1 downto 0);
           num2_i : in std_logic_vector(data_width-1 downto 0);
           res_o : out std_logic_vector(2*data_width-1 downto 0)
    );
end multiplier;

architecture Behavioral of multiplier is

begin
    res_o <= std_logic_vector(signed(num1_i) * signed(num2_i));    

end Behavioral;
