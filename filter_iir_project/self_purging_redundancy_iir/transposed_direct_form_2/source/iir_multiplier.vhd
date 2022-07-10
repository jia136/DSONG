----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2022 05:34:05 PM
-- Design Name: 
-- Module Name: iir_multiplier - Behavioral
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
--use work.fixed_pkg.all;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity iir_multiplier is
    generic(data_width : natural := 32);
    Port ( num1_i : in std_logic_vector(data_width-1 downto 0);
           num2_i : in std_logic_vector(data_width-1 downto 0);
           res_o : out std_logic_vector(data_width-1 downto 0)
    );
end iir_multiplier;

architecture Behavioral of iir_multiplier is
    signal number_1: sfixed(4 downto -27):= (others => '0');
    signal number_2: sfixed(4 downto -27):= (others => '0');
    signal result: sfixed(4 downto -27):= (others => '0');
    signal num1multnum2:sfixed(sfixed_high (number_1,'*',number_2) downto sfixed_low (number_1,'*',number_2));
begin

    number_1 <= to_sfixed(num1_i, 4, -27);
    number_2 <= to_sfixed(num2_i, 4, -27);
    num1multnum2 <= number_1*number_2;
    result <= resize(arg=> num1multnum2, size_res=> number_1, overflow_style=>fixed_saturate,round_style=>fixed_round);
    res_o <= to_slv(result);

end Behavioral;
