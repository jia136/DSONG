----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2022 12:27:06 PM
-- Design Name: 
-- Module Name: iir_module - Behavioral
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
use work.util_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity iir_module is
    generic(data_width : natural := 32;
            iir_ord_x2 : natural := 12);
    Port (clk_i : in std_logic;
          we_i : in std_logic;
          data_i: in std_logic_vector(data_width -1 downto 0);
          coef_value_i: in std_logic_vector(data_width-1 downto 0);
          coef_address_i : in std_logic_vector(log2c(iir_ord_x2 + 1)-1 downto 0);
          data_o : out std_logic_vector(data_width-1 downto 0));

end iir_module;

architecture Behavioral of iir_module is
    type std_1d is array (iir_ord_x2 + 1 downto 0) of std_logic_vector(data_width-1 downto 0);
    type std_2d is array (iir_ord_x2 + 1 downto 0) of std_logic_vector(2*data_width-1 downto 0);
    type coef_type is array (0 to iir_ord_x2 + 1) of std_logic_vector(data_width-1 downto 0);
    signal mac_inter_reg : std_1d:= (others=>(others=>'0'));
    signal mac_inter_add : std_2d:= (others=>(others=>'0'));
    signal coef_s : coef_type := (others=>(others=>'0'));

begin

    coef_process: process(clk_i)
    begin
        if(rising_edge(clk_i))then
            if(we_i = '1')then
                coef_s(to_integer(unsigned(coef_address_i))) <= coef_value_i;
            end if;
        end if;
    end process coef_process;

   zero_section:
   entity work.mac_module(behavioral)
        generic map(data_width => data_width)
        port map(clk_i => clk_i,
                 coef_i => coef_s(0),
                 reg_i => data_i,
                 add_i => mac_inter_add(1),
                 reg_o => mac_inter_reg(0),
                 add_o => mac_inter_add(0));
   
   first_section:
   for i in 1 to (iir_ord_x2/2)-1 generate
        mac_section:
        entity work.mac_module(behavioral)
        generic map(data_width => data_width)
        port map(clk_i => clk_i,
                 coef_i => coef_s(i),
                 reg_i => mac_inter_reg(i-1),
                 add_i => mac_inter_add(i+1),
                 reg_o => mac_inter_reg(i),
                 add_o => mac_inter_add(i));
  end generate;
  
  second_section: 
  entity work.multiplier
        generic map(data_width => data_width)
        port map (num1_i => mac_inter_reg(iir_ord_x2/2-1),
                  num2_i => coef_s(iir_ord_x2/2),
                  res_o => mac_inter_add(iir_ord_x2/2));
                  
--third_section:
--   entity work.mac_spec(behavioral)
--        generic map(data_width => data_width)
--        port map(clk_i => clk_i,
--                 add1_i => mac_inter_add(0),
--                 add2_i => mac_inter_add(iir_ord_x2/2+2),
--                 reg_i => mac_inter_add(iir_ord_x2/2+1)(2*data_width-2 downto data_width-1),
--                 reg_o => mac_inter_reg(iir_ord_x2/2+1),
--                 add_o => mac_inter_add(iir_ord_x2/2+1));
  third_section_a:  
  entity work.adder(behavioral)
      generic map(data_width => data_width)
      port map(num1_i => mac_inter_add(0),
               num2_i => mac_inter_add(iir_ord_x2/2+2),
               sum_o => mac_inter_add(iir_ord_x2/2+1));
      
  third_section_b:  
  entity work.mac_spec(behavioral)
      generic map(data_width => data_width)
      port map(clk_i => clk_i,
               reg_i => mac_inter_add(iir_ord_x2/2+1)(2*data_width-2 downto data_width-1),
               reg_o => mac_inter_reg(iir_ord_x2/2+1));  
  
  
  fourth_section:
   for i in iir_ord_x2/2+2 to iir_ord_x2 generate
        mac_section:
        entity work.mac_module(behavioral)
        generic map(data_width => data_width)
        port map(clk_i => clk_i,
                 coef_i => coef_s(i),
                 reg_i => mac_inter_reg(i-1),
                 add_i => mac_inter_add(i+1),
                 reg_o => mac_inter_reg(i),
                 add_o => mac_inter_add(i));
  end generate;
  
  fifth_section:
  entity work.multiplier
        generic map(data_width => data_width)
        port map (num1_i => mac_inter_reg(iir_ord_x2),
                  num2_i => coef_s(iir_ord_x2+1),
                  res_o => mac_inter_add(iir_ord_x2+1));
   
  process(clk_i)
    begin
        if(clk_i'event and clk_i='1')then
            data_o <= mac_inter_add(iir_ord_x2/2+1)(2*(data_width-1) downto data_width-1);
        end if;
    end process; 
  
end Behavioral;
