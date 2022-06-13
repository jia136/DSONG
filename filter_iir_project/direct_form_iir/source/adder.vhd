----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2022 11:46:39 AM
-- Design Name: 
-- Module Name: adder - Behavioral
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

entity adder is
    generic(data_width : natural := 32);
    Port ( num1_i : in std_logic_vector(2*data_width-1 downto 0);
           num2_i : in std_logic_vector(2*data_width-1 downto 0);
           sum_o : out std_logic_vector(2*data_width-1 downto 0)
    );
end adder;

architecture Behavioral of adder is
    signal tmp_sum : std_logic_vector(2*data_width downto 0):= (others => '0');
begin    
    --bez otornosti na ogranicenja prekoracenja
    --sum_o <= std_logic_vector(signed(num1_i) + signed(num2_i));
    
    --slucaj prekoracenja
    tmp_sum <= std_logic_vector(resize(signed(num1_i), 2*data_width+1) + resize(signed(num2_i), 2*data_width+1));
    
    process(num1_i, num2_i, tmp_sum) is
    begin
       if (tmp_sum(2*data_width) = '0') and (tmp_sum(2*data_width-1) = '1') then
            sum_o <= (2*data_width-1 => '0', others => '1');
            report "OVERFLOW DETECTED" severity warning;
        elsif (tmp_sum(2*data_width) = '1') and (tmp_sum(2*data_width-1) = '0') then
            sum_o <= (2*data_width-1 => '1', others => '0');
            report "UNDERFLOW DETECTED" severity warning;
        else
            sum_o <= tmp_sum(2*data_width-1 downto 0);
       end if;
    end process;
    
    
    
    
end Behavioral;