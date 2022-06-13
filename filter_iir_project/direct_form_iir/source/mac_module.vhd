----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2022 11:21:32 AM
-- Design Name: 
-- Module Name: mac_module - Behavioral
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

entity mac_module is
    generic (data_width : natural := 32);
    Port ( clk_i : in std_logic;
           reg_i : in std_logic_vector(data_width-1 downto 0);
           add_i : in std_logic_vector(2*data_width-1 downto 0);
           coef_i : in std_logic_vector(data_width-1 downto 0);
           reg_o : out std_logic_vector(data_width-1 downto 0);
           add_o : out std_logic_vector(2*data_width-1 downto 0)
           );
end mac_module;

architecture Behavioral of mac_module is
    signal reg_s : std_logic_vector(data_width-1 downto 0) :=(others=>'0');
    signal add_s : std_logic_vector(2*data_width-1 downto 0) :=(others=>'0');
begin

    clk_process: process(clk_i)
    begin
        if(rising_edge(clk_i)) then
            reg_s <= reg_i;
        end if;
    end process clk_process;

--    multiplier : entity work.multiplier
--        generic map(data_width => data_width)
--        port map (num1_i => reg_i,
--                  num2_i => coef_i,
--                  res_o => add_s);
                  
--    adder: entity work.adder
--        generic map(data_width => data_width)
--        port map (num1_i => add_s,
--                  num2_i => add_i,
--                  sum_o => add_o);
                  
    add_o <= std_logic_vector(signed(add_i) + (signed(reg_i)*signed(coef_i)));
    
    reg_o <= reg_s;
                      
end Behavioral;
