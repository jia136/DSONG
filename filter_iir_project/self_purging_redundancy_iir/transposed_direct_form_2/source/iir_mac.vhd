----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2022 05:12:05 PM
-- Design Name: 
-- Module Name: iir_mac - Behavioral
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
--use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity iir_mac is
    generic (data_width : natural := 32);
    Port (clk_i : in std_logic;
          input1_i : in std_logic_vector(data_width-1 downto 0);
          input2_i : in std_logic_vector(data_width-1 downto 0);
          add_i : in std_logic_vector(data_width-1 downto 0);
          coef1_i : in std_logic_vector(data_width-1 downto 0);
          coef2_i : in std_logic_vector(data_width-1 downto 0);
          reg_o : out std_logic_vector(data_width-1 downto 0));
end iir_mac;

architecture Behavioral of iir_mac is
        signal reg_s : std_logic_vector(data_width-1 downto 0) :=(others=>'0');
        signal add_s : std_logic_vector(data_width-1 downto 0) :=(others=>'0');
        signal multi1_s : std_logic_vector(data_width-1 downto 0) :=(others=>'0');
        signal multi2_s : std_logic_vector(data_width-1 downto 0) :=(others=>'0');
begin
    
    multiplier1 : entity work.iir_multiplier
        generic map(data_width => data_width)
        port map (num1_i => input1_i,
                  num2_i => coef1_i,
                  res_o => multi1_s);

    multiplier2 : entity work.iir_multiplier
        generic map(data_width => data_width)
        port map (num1_i => input2_i,
                  num2_i => coef2_i,
                  res_o => multi2_s);

    adder: entity work.iir_adder
        generic map(data_width => data_width)
        port map (num1_i => multi1_s,
                  num2_i => multi2_s,
                  num3_i => add_i,
                  sum_o => add_s);

     clk_process: process(clk_i)
        begin
            if(rising_edge(clk_i)) then
                reg_s <= add_s;
            end if;
        end process clk_process;

    reg_o <= reg_s;

end Behavioral;
