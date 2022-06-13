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
       sw_o : out std_logic_vector(data_width-1 downto 0));
end switch;

architecture Behavioral of switch is
    signal sw_s : std_logic_vector(data_width-1 downto 0) :=(others=>'0');
    signal prev_error_s : std_logic :='0';
begin    

    process(clk_i)begin
        if(clk_i'event and clk_i='1') then        
            if(sw_s = voter_i and prev_error_s = '0') then
                sw_s <= mac_i;
            else
                if(init_i = '1') then
                  prev_error_s <= '0';
                  sw_s <= mac_i;
                else
                  prev_error_s <= '1';
                  sw_s <= (others=>'0');
               end if;
            end if;
       end if;        
    end process;
    
    sw_o <= sw_s;

end Behavioral;
