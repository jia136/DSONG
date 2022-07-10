----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2022 09:49:51 AM
-- Design Name: 
-- Module Name: switch - Behavioral
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

entity switch is
 generic (data_width : natural := 32);
 Port (clk_i : in std_logic;
       init_i : in std_logic;
       mac_i : in std_logic_vector(data_width-1 downto 0);
       voter_i : in std_logic_vector(data_width-1 downto 0);
       sw_o : inout std_logic_vector(data_width-1 downto 0));
end switch;

architecture Behavioral of switch is
    signal sw_s : std_logic_vector(data_width-1 downto 0) :=(others=>'0');
    signal prev_value: std_logic_vector(data_width-1 downto 0) := (others=>'0');
    signal current_value: std_logic_vector(data_width-1 downto 0) := (others=>'0');
    signal error_s : std_logic :='0';
begin
   
--    logic_process: process(init_i,mac_i,voter_i,error_s)
--    begin
--      if(sw_s = voter_i and error_s = '0') then
--          sw_s <= mac_i;
--          sw_o <= mac_i;
--          report "line 55";
--      else
--          if(init_i = '0') then
--              error_s <= '1';
--              sw_s <= (others=>'0');
--              sw_o <= (others=>'0');                       
--          else
--              error_s <= '0';
--              sw_o <= mac_i;
--              sw_s <= mac_i;
--              report "line 66"; 
--          end if;           
--      end if;               
--    end process logic_process;


    sw_process: process(error_s,mac_i)
    begin
        if(error_s = '1') then
            sw_o <= (others => '0');
        else            
            sw_o <= mac_i;
        end if;
    end process sw_process;

    clk_process: process(clk_i)
    begin
        if(rising_edge(clk_i)) then
            if(init_i = '1') then
                error_s <= '0';
            else              
                if(not(sw_o = voter_i))then
                    error_s <= '1';
                end if;
            end if;          
       end if;              
    end process clk_process;

end Behavioral;
