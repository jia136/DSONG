puts ".........................."
puts "... TCL file ..."

#synth_design -rtl -name rtl_1
set redundancy [get_property VALUE [get_objects /iir_tb/iir_filter_comp/redundancy]]
set order [get_property VALUE [get_objects /iir_tb/iir_filter_comp/iir_ord]]
puts "IIR order: $order"
puts "Redundancy: $redundancy"

if {$redundancy == 3} {
    
    set force_path /iir_tb/iir_filter_comp/\\all_section(1)\\/\\section(2)\\/mac_section/add_s
    add_force $force_path -radix hex 16x000000468b0cb481 5000ns -cancel_after 10000ns
    add_wave {{/iir_tb/iir_filter_comp/\all_section(1)\/\section(2)\/mac_section/add_s}}
        
} elseif {$redundancy == 5} {
  
    set force_path_5_a /iir_tb/iir_filter_comp/\\all_section(2)\\/\\section(3)\\/mac_section/add_s
    set force_path_5_b /iir_tb/iir_filter_comp/\\all_section(2)\\/\\section(5)\\/mac_section/add_s
         
    add_force $force_path_5_a -radix hex 16x000000468b0cb481 5000ns -cancel_after 9000ns
    add_force $force_path_5_b -radix hex 16x000000ffffffffff 5100ns -cancel_after 10100ns       
                    
    set force_path_init_i /iir_tb/iir_filter_comp/\\all_section(2)\\/\\section(3)\\/switch_section/init_i
    
    add_force $force_path_init_i 1 10000ns -cancel_after 10500ns
                   
    add_wave {{/iir_tb/iir_filter_comp/\all_section(2)\/\section(3)\/mac_section/add_s}}
    add_wave {{/iir_tb/iir_filter_comp/\all_section(2)\/\section(5)\/mac_section/add_s}}
    add_wave {{/iir_tb/iir_filter_comp/\all_section(2)\/\section(3)\/switch_section/init_i}}
                     
} elseif {$redundancy == 7} {
    set force_path_7_a /iir_tb/iir_filter_comp/\\all_section(2)\\/\\section(1)\\/mac_section/add_s 
    set force_path_7_b /iir_tb/iir_filter_comp/\\all_section(2)\\/\\section(4)\\/mac_section/add_s
    set force_path_7_c /iir_tb/iir_filter_comp/\\all_section(2)\\/\\section(6)\\/mac_section/add_s 
    set force_path_7_d /iir_tb/iir_filter_comp/\\all_section(2)\\/\\section(7)\\/mac_section/add_s                
            
    add_force $force_path_7_a -radix hex 16x000000468b0cb481 5000ns -cancel_after 9000ns
    add_force $force_path_7_b -radix hex 16xffffffffffffffff 6000ns -cancel_after 12000ns
    add_force $force_path_7_c -radix hex 16x0000000000000000 6000ns -cancel_after 10000ns
    add_force $force_path_7_d -radix hex 16xffffffffffffffff 7000ns -cancel_after 11000ns
            
    set force_path_init_i /iir_tb/iir_filter_comp/\\all_section(2)\\/\\section(7)\\/switch_section/init_i
    
    add_force $force_path_init_i 1 10000ns -cancel_after 13000ns
              
    add_wave {{/iir_tb/iir_filter_comp/\all_section(2)\/\section(1)\/mac_section/add_s}}
    add_wave {{/iir_tb/iir_filter_comp/\all_section(2)\/\section(4)\/mac_section/add_s}}
    add_wave {{/iir_tb/iir_filter_comp/\all_section(2)\/\section(6)\/mac_section/add_s}} 
    add_wave {{/iir_tb/iir_filter_comp/\all_section(2)\/\section(7)\/mac_section/add_s}}
    add_wave {{/iir_tb/iir_filter_comp/\all_section(2)\/\section(7)\/switch_section/init_i}}
    
} else {
    puts "Unexpected redundancy value."
    set force_path /iir_tb/iir_filter_comp/\\all_section(1)\\/\\section(1)\\/mac_section/add_s
    add_force $force_path -radix hex 16x000000ffffffffff 3000ns -cancel_after 5000ns
    add_wave {{/iir_tb/iir_filter_comp/\\all_section(1)\\/\\section(1)\\/mac_section/add_s}}
}

add_wave {{/iir_tb/iir_filter_comp/\all_section(2)\/voter_section/voter_i}}
add_wave {{/iir_tb/iir_filter_comp/\all_section(2)\/voter_section/voter_o}}
  
set force_path_multiplier /iir_tb/iir_filter_comp/\\last_section(1)\\/mac_section/multiplier1/res_o
add_force $force_path_multiplier -radix hex 16x0000000000000000 10000ns -cancel_after 12000ns
  
add_wave {{/iir_tb/iir_filter_comp/\last_section(1)\/mac_section/multiplier1/res_o}}
add_wave {{/iir_tb/iir_filter_comp/voter_last/voter_i}}  
add_wave {{/iir_tb/iir_filter_comp/voter_last/voter_o}}


   