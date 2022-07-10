----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/19/2022 05:50:51 PM
-- Design Name: 
-- Module Name: iir_filter - Behavioral
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
use work.util_pkg.all;
use work.arrays_package.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity iir_filter is
  generic(data_width : natural := 32;
          redundancy : natural := 5;--no of redundant modules
          iir_ord : natural := 6);--iir filter order
  Port (clk_i : in std_logic;
        we_i : in std_logic;
        data_i: in std_logic_vector(data_width -1 downto 0);
        coef_value_i: in std_logic_vector(data_width-1 downto 0);
        coef_address_i : in std_logic_vector(log2c(2*iir_ord + 1)-1 downto 0);
        data_o : out std_logic_vector(data_width-1 downto 0));
end iir_filter;

architecture Behavioral of iir_filter is
    type coef_type is array (0 to 2*iir_ord + 1) of std_logic_vector(data_width-1 downto 0);
    type std_d is array (redundancy*(iir_ord + 1) downto 0) of std_logic_vector(data_width-1 downto 0);
    signal coef_s : coef_type := (others=>(others=>'0'));
    signal mac_inter_reg : std_d:= (others=>(others=>'0'));
    signal voter_inter_input_reg : array_type(redundancy*iir_ord+redundancy downto 0):= (others=>(others=>'0'));
    signal voter_inter_output_reg : std_d := (others=>(others=>'0'));
begin

      coef_process: process(clk_i)
      begin
          if(rising_edge(clk_i))then
              if(we_i = '1')then
                  coef_s(to_integer(unsigned(coef_address_i))) <= coef_value_i;
              end if;
          end if;
      end process coef_process;
     
     -----LAST SECTION----- 
     last_section:     
        for i in 1 to redundancy generate        
        mac_section:
        entity work.iir_mac(behavioral)
            generic map(data_width => data_width)
            port map(clk_i => clk_i,
                     input1_i => data_i,
                     input2_i => voter_inter_output_reg(0),
                     add_i => (others=>'0'),
                     coef1_i => coef_s(iir_ord),
                     coef2_i => coef_s(2*iir_ord+1),
                     reg_o => mac_inter_reg(redundancy*iir_ord + i));
                     --reg_o => voter_inter_output_reg(iir_ord));
        switch_section:
        entity work.switch(behavioral)
            generic map(data_width => data_width)
            port map(clk_i => clk_i,
                     init_i => '0',
                     mac_i => mac_inter_reg(redundancy*iir_ord + i),
                     voter_i => voter_inter_output_reg(iir_ord),
                     sw_o => voter_inter_input_reg(redundancy*iir_ord + i)); 
        end generate;      
        voter_last:
           entity work.voter(behavioral)
               generic map(data_width => data_width,
                           no_of_modules => redundancy)
               port map(voter_i => voter_inter_input_reg(redundancy*iir_ord+ redundancy downto redundancy*iir_ord+1),
                        voter_o => voter_inter_output_reg(iir_ord));
      -----END OF LAST SECTION-----
      
      -----ALL SECTIONS-----
      all_section:
      for i in iir_ord-1 downto 1 generate
        section:
           for j in 1 to redundancy generate       
            mac_section:
            entity work.iir_mac(behavioral)
            generic map(data_width => data_width)
            port map(clk_i => clk_i,
                     input1_i => data_i,
                     input2_i => voter_inter_output_reg(0),
                     add_i => voter_inter_output_reg(i+1),
                     coef1_i => coef_s(i),
                     coef2_i => coef_s(i+iir_ord+1),
                     reg_o => mac_inter_reg(redundancy*i + j));             
                     --reg_o => voter_inter_output_reg(i));         
                     
            switch_section:
            entity work.switch(behavioral)
            generic map(data_width => data_width)
            port map(clk_i => clk_i,
                     init_i => '0',
                     mac_i => mac_inter_reg(redundancy*i + j),
                     voter_i => voter_inter_output_reg(i),
                     sw_o => voter_inter_input_reg(redundancy*i + j));
             
            end generate;
            
           voter_section:
           entity work.voter(behavioral)
               generic map(data_width => data_width,
                           no_of_modules => redundancy)
               port map(voter_i => voter_inter_input_reg(redundancy*i+redundancy downto redundancy*i+1),
                        voter_o => voter_inter_output_reg(i));
      end generate;
      -----END OF ALL SECTION-----
        
      -----ZERO SECTION-----
      zero_section:
      for i in 1 to redundancy generate        
       mac_section:
        entity work.iir_mac_zero(behavioral)
            generic map(data_width => data_width)
            port map(clk_i => clk_i,
                     input1_i => data_i,
                     add_i => voter_inter_output_reg(1),
                     coef1_i => coef_s(0),
                     output_o => mac_inter_reg(i));
                     --output_o => voter_inter_output_reg(0));
                                          
       switch_section:
        entity work.switch(behavioral)
            generic map(data_width => data_width)
            port map(clk_i => clk_i,
                     init_i => '0',
                     mac_i => mac_inter_reg(i),
                     voter_i => voter_inter_output_reg(0),
                     sw_o => voter_inter_input_reg(i)); 
     end generate;
      
      voter_zero:
           entity work.voter(behavioral)
               generic map(data_width => data_width,
                           no_of_modules => redundancy)
               port map(voter_i => voter_inter_input_reg(redundancy downto 1),
                        voter_o => voter_inter_output_reg(0));
    -----END OF ZERO SECTION-----
         
    process(clk_i)
    begin
        if(clk_i'event and clk_i='1')then
            data_o <= voter_inter_output_reg(0);
        end if;
    end process;

end Behavioral;
