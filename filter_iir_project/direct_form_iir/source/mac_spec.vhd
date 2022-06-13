----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2022 11:06:32 AM
-- Design Name: 
-- Module Name: mac_spec - Behavioral
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

entity mac_spec is
generic (data_width : natural := 32);
    Port ( clk_i : in std_logic;
           reg_i : in std_logic_vector(data_width-1 downto 0);           
           --add1_i : in std_logic_vector(2*data_width-1 downto 0);--new added
           --add2_i : in std_logic_vector(2*data_width-1 downto 0);--new added
           --add_o : out std_logic_vector(2*data_width-1 downto 0);--new added
           reg_o : out std_logic_vector(data_width-1 downto 0));
end mac_spec;

architecture Behavioral of mac_spec is
    signal reg_s : std_logic_vector(data_width-1 downto 0):=(others=>'0');
begin
 
    clk_process: process(clk_i)
    begin
        if(clk_i'event and clk_i='1') then
            reg_s <= reg_i;
        end if;
    end process clk_process;
    
    reg_o <= std_logic_vector(reg_s);

end Behavioral;
