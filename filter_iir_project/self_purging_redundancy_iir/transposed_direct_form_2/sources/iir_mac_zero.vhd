----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2022 06:26:41 PM
-- Design Name: 
-- Module Name: iir_mac_zero - Behavioral
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
--use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity iir_mac_zero is
generic (data_width : natural := 32);
    Port (clk_i     : in std_logic;
          input1_i  : in std_logic_vector(data_width-1 downto 0);
          add_i     : in std_logic_vector(data_width-1 downto 0);
          coef1_i   : in std_logic_vector(data_width-1 downto 0);
          output_o  : out std_logic_vector(data_width-1 downto 0));
end iir_mac_zero;

architecture Behavioral of iir_mac_zero is
    signal multi1_s : std_logic_vector(data_width-1 downto 0) :=(others=>'0');
    signal sum_s : std_logic_vector(data_width-1 downto 0) :=(others=>'0');
begin
   multiplier : entity work.iir_multiplier
        generic map(data_width => data_width)
        port map (num1_i => input1_i,
                  num2_i => coef1_i,
                  res_o => multi1_s);
                  
   adder: entity work.iir_adder
        generic map(data_width => data_width)
        port map (num1_i => multi1_s,
                  num2_i => (others=>'0'),
                  num3_i => add_i,
                  sum_o => sum_s);           
   output_o <= sum_s;

end Behavioral;