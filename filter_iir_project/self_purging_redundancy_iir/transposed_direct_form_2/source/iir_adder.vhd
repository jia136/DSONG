----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2022 05:33:35 PM
-- Design Name: 
-- Module Name: iir_adder - Behavioral
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
use IEEE.Std_logic_signed.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

entity iir_adder is
    generic(data_width : natural := 32);
    Port ( num1_i : in std_logic_vector(data_width-1 downto 0);
           num2_i : in std_logic_vector(data_width-1 downto 0);
           num3_i : in std_logic_vector(data_width-1 downto 0);
           sum_o : out std_logic_vector(data_width-1 downto 0)
    );
end iir_adder;

architecture Behavioral of iir_adder is
    signal number_1: sfixed(4 downto -27):= (others => '0');
    signal number_2: sfixed(4 downto -27):= (others => '0');
    signal number_3: sfixed(4 downto -27):= (others => '0');
    signal result: sfixed(4 downto -27):= (others => '0');
    signal tmp1: sfixed(5 downto -27):= (others => '0');
    signal tmp2: sfixed(6 downto -27):= (others => '0');
begin

    number_1 <= to_sfixed(num1_i, 4, -27);
    number_2 <= to_sfixed(num2_i, 4, -27);
    number_3 <= to_sfixed(num3_i, 4, -27);
    tmp1 <= number_1 + number_3;
    tmp2 <= tmp1 - number_2;
    result <= resize(arg=> tmp2, size_res => number_1, overflow_style=>fixed_saturate,round_style=>fixed_round);   
    sum_o <= to_slv(result);
      
end Behavioral;
