----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2022 12:07:06 PM
-- Design Name: 
-- Module Name: iir_tb - Behavioral
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
--use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_1164.ALL;

--use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.util_pkg.all;
use work.txt_util.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity iir_tb is
     generic(data_width : natural := 32;
            iir_ord : natural := 6);
--  Port ( );
end iir_tb;

architecture Behavioral of iir_tb is

    constant period : time := 20 ns;
    signal clk_i_s : std_logic;

    signal data_i_s : std_logic_vector(data_width-1 downto 0);
    signal data_o_s : std_logic_vector(data_width-1 downto 0);
    signal data_exp_s : std_logic_vector(data_width-1 downto 0);
    signal coef_addr_i_s : std_logic_vector(log2c(2*iir_ord+1)-1 downto 0);
    signal coef_i_s : std_logic_vector(data_width-1 downto 0);
    signal we_i_s : std_logic;
    
    signal start_check : std_logic := '0';

begin

    iir_filter_comp:
    entity work.iir_filter(behavioral)
    generic map( data_width => data_width,
                iir_ord => iir_ord)
      port map ( clk_i => clk_i_s,
                we_i =>we_i_s,
                coef_address_i =>coef_addr_i_s,
                coef_value_i =>coef_i_s,
                data_i =>data_i_s,
                data_o => data_o_s);
                
    clk_process:
    process
    begin
        clk_i_s <= '0';
        wait for period/2;
        clk_i_s <= '1';
        wait for period/2;    
    end process;
       
    stim_process:
    process
        variable tv : line;
        file read_input_vector: text;
        file read_input_coef: text;
    begin    
        file_open(read_input_vector, "C:\Users\Jelena\Desktop\filter_iir_dsong\filter_iir_dsong.srcs\sim_1\new\input_iir_buttord.txt", read_mode);
        file_open(read_input_coef, "C:\Users\Jelena\Desktop\filter_iir_dsong\filter_iir_dsong.srcs\sim_1\new\coef_iir_buttord.txt", read_mode);
        
        --upis koeficijenata filtra
        data_i_s <= (others=>'0');
        wait until falling_edge(clk_i_s);
        for i in 0 to 2*iir_ord+1 loop
            we_i_s <= '1';
            coef_addr_i_s <= std_logic_vector(to_unsigned(i,log2c(2*iir_ord+1)));
            readline(read_input_coef,tv);
            coef_i_s <= to_std_logic_vector(string(tv));
            wait until falling_edge(clk_i_s);
        end loop;
        
        --upis ulaznih podataka - signala
        while not endfile(read_input_vector) loop
            readline(read_input_vector,tv);
            data_i_s <= to_std_logic_vector(string(tv));
            start_check <= '1';
            wait until falling_edge(clk_i_s);            
        end loop;
        start_check <= '0';
        report "verification done!" severity failure;
    end process;

    check_process:
    process
        variable check_v : line;
        variable tmp : std_logic_vector(data_width-1 downto 0);
        file read_output_vector: text;
    begin
        file_open(read_output_vector, "C:\Users\Jelena\Desktop\filter_iir_dsong\filter_iir_dsong.srcs\sim_1\new\dsp_expected_iir.txt", read_mode);
        wait until start_check = '1';
        --wait until rising_edge(clk_i_s);
        while(true)loop
            wait until rising_edge(clk_i_s);
            readline(read_output_vector,check_v);
            tmp := to_std_logic_vector(string(check_v));
            data_exp_s <= tmp;
            wait for 1ns;
            if(abs(signed(tmp) - signed(data_o_s)) > "00000000000000000000000000001111")then
                report "Result mismatch!" severity warning;
            end if;
        end loop;
    end process;  

end Behavioral;
