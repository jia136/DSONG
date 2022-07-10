puts ".........................."
puts "........ TCL file ........"

#synth_design -rtl -name rtl_1
set redundancy [get_property VALUE [get_objects /iir_tb/iir_filter_comp/redundancy]]
set order [get_property VALUE [get_objects /iir_tb/iir_filter_comp/iir_ord]]
puts "IIR order: $order"
puts "Redundancy: $redundancy"

set upper_limit [expr {int($order-1)}]
proc random_int {upper_limit_proc {lower_limit_proc 1}} {
    global myrand
    set myrand [expr {int(rand()*($upper_limit_proc - $lower_limit_proc + 1) + $lower_limit_proc)}]
    return $myrand
}

set rnd_value_a_order [random_int $upper_limit 1]
set rnd_value_b_order [random_int $upper_limit 1]
if {$rnd_value_a_order == $rnd_value_b_order} {
    if {$rnd_value_a_order == $upper_limit} {
        set rnd_value_b_order [expr {int($upper_limit - 2)}]
    } else {
        set rnd_value_b_order [expr {int($rnd_value_a_order + 1)}]
    }
}
set rnd_value_a_redundancy [random_int $redundancy 1]
set rnd_value_b_redundancy [random_int $redundancy 1]
set rnd_value_c_redundancy [random_int $redundancy 1]
set rnd_value_d_redundancy [random_int $redundancy 1]


if {$redundancy == 3} {

    set force_path1 /iir_tb/iir_filter_comp/\\all_section($rnd_value_a_order\)\\/\\section($rnd_value_a_redundancy\)\\/mac_section/add_s
    add_force $force_path1 -radix hex 16xffff1c18 5000ns -cancel_after 10000ns

    set force_path2 /iir_tb/iir_filter_comp/\\all_section($rnd_value_b_order\)\\/\\section($rnd_value_b_redundancy\)\\/mac_section/multi1_s
    add_force $force_path2 -radix hex 16x00000000 8000ns -cancel_after 11000ns
                                      
    set force_path_init_i /iir_tb/iir_filter_comp/\\all_section($rnd_value_b_order\)\\/\\section($rnd_value_b_redundancy\)\\/switch_section/init_i
    add_force $force_path_init_i 1 12000ns -cancel_after 12500ns
        
    puts "Forsed signal: /iir_tb/iir_filter_comp/\\all_section($rnd_value_a_order\)\\/\\section($rnd_value_a_redundancy\)\\/mac_section/add_s"
    puts "Forsed signal: /iir_tb/iir_filter_comp/\\all_section($rnd_value_b_order\)\\/\\section($rnd_value_b_redundancy\)\\/mac_section/multi1_s"
    puts "Forsed signal: /iir_tb/iir_filter_comp/\\all_section($rnd_value_b_order\)\\/\\section($rnd_value_b_redundancy\)\\/switch_section/init_i"
    
    set force_path_zero /iir_tb/iir_filter_comp/\\zero_section(1)\\/mac_section/sum_s
    add_force $force_path_zero -radix hex 16x00000000 3000ns -cancel_after 4000ns
    set force_path_zero_init_i /iir_tb/iir_filter_comp/\\zero_section(1)\\/switch_section/init_i
    add_force $force_path_zero_init_i 1 4100ns -cancel_after 5000ns
    
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(1)\/mac_section/sum_s}}
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(1)\/switch_section/init_i}}
   
} elseif {$redundancy == 5} {

    set force_path_5_a /iir_tb/iir_filter_comp/\\all_section($rnd_value_a_order\)\\/\\section($rnd_value_a_redundancy\)\\/mac_section/add_s
    set force_path_5_reg /iir_tb/iir_filter_comp/\\all_section($rnd_value_a_order\)\\/\\section($rnd_value_b_redundancy\)\\/mac_section/reg_s
    set force_path_5_b /iir_tb/iir_filter_comp/\\all_section($rnd_value_b_order\)\\/\\section($rnd_value_b_redundancy\)\\/mac_section/add_s
                                         
    add_force $force_path_5_a -radix hex 16x0b0cb481 5000ns -cancel_after 9000ns
    add_force $force_path_5_b -radix hex 16x00ffffff 5100ns -cancel_after 10100ns     
    add_force $force_path_5_reg -radix hex 16x00000000 5100ns -cancel_after 10100ns     
                    
    set force_path_init_i /iir_tb/iir_filter_comp/\\all_section($rnd_value_a_order\)\\/\\section($rnd_value_a_redundancy\)\\/switch_section/init_i
    add_force $force_path_init_i 1 10000ns -cancel_after 10500ns
          
    puts "Forced signal: /iir_tb/iir_filter_comp/\\all_section($rnd_value_a_order)\\/\\section($rnd_value_a_redundancy)\\/mac_section/add_s"
    puts "Forced signal: /iir_tb/iir_filter_comp/\\all_section($rnd_value_a_order\)\\/\\section($rnd_value_b_redundancy\)\\/mac_section/reg_s"
    puts "Forced signal: /iir_tb/iir_filter_comp/\\all_section($rnd_value_b_order\)\\/\\section($rnd_value_b_redundancy\)\\/mac_section/add_s"
    puts "Forces signal: /iir_tb/iir_filter_comp/\\all_section($rnd_value_a_order\)\\/\\section($rnd_value_a_redundancy\)\\/switch_section/init_i"
  
    set force_path_zero1 /iir_tb/iir_filter_comp/\\zero_section(1)\\/mac_section/sum_s
    add_force $force_path_zero1 -radix hex 16x00000000 3000ns -cancel_after 4000ns
    set force_path_zero2 /iir_tb/iir_filter_comp/\\zero_section(2)\\/mac_section/sum_s
    add_force $force_path_zero2 -radix hex 16xffffffff 3100ns -cancel_after 4100ns
    set force_path_zero3 /iir_tb/iir_filter_comp/\\zero_section(3)\\/mac_section/sum_s
    add_force $force_path_zero3 -radix hex 16x00000000 3200ns -cancel_after 4200ns
    set force_path_zero_init_i /iir_tb/iir_filter_comp/\\zero_section(2)\\/switch_section/init_i
    add_force $force_path_zero_init_i 1 4100ns -cancel_after 5000ns    
        
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(1)\/mac_section/sum_s}}       
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(2)\/mac_section/sum_s}}
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(3)\/mac_section/sum_s}}
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(2)\/switch_section/init_i}}       

} elseif {$redundancy == 7} {

    set rnd_value_a_order 1
    set rnd_value_b_order 2 
    set rnd_value_c_order 3
    set rnd_value_d_order 5    
                       
    set force_path_7_a /iir_tb/iir_filter_comp/\\all_section($rnd_value_a_order\)\\/\\section($rnd_value_a_redundancy\)\\/mac_section/add_s 
    set force_path_7_b /iir_tb/iir_filter_comp/\\all_section($rnd_value_b_order\)\\/\\section($rnd_value_b_redundancy\)\\/mac_section/add_s
    set force_path_7_c /iir_tb/iir_filter_comp/\\all_section($rnd_value_c_order\)\\/\\section($rnd_value_c_redundancy\)\\/mac_section/add_s 
    set force_path_7_d /iir_tb/iir_filter_comp/\\all_section($rnd_value_d_order\)\\/\\section($rnd_value_d_redundancy\)\\/mac_section/add_s                
            
    add_force $force_path_7_a -radix hex 16x000da481 5000ns -cancel_after 9000ns
    add_force $force_path_7_b -radix hex 16xffffffff 6000ns -cancel_after 12000ns
    add_force $force_path_7_c -radix hex 16x00000000 6000ns -cancel_after 10000ns
    add_force $force_path_7_d -radix hex 16xffffffff 7000ns -cancel_after 11000ns
            
    set force_path_init_i /iir_tb/iir_filter_comp/\\all_section($rnd_value_a_order\)\\/\\section($rnd_value_a_redundancy\)\\/switch_section/init_i
    
    add_force $force_path_init_i 1 10000ns -cancel_after 13000ns    
        
    puts "Forsed signal: /iir_tb/iir_filter_comp/\\all_section($rnd_value_a_order\)\\/\\section($rnd_value_a_redundancy\)\\/mac_section/add_s"
    puts "Forsed signal: /iir_tb/iir_filter_comp/\\all_section($rnd_value_b_order\)\\/\\section($rnd_value_b_redundancy\)\\/mac_section/add_s"
    puts "Forsed signal: /iir_tb/iir_filter_comp/\\all_section($rnd_value_c_order\)\\/\\section($rnd_value_c_redundancy\)\\/mac_section/add_s"
    puts "Forsed signal: /iir_tb/iir_filter_comp/\\all_section($rnd_value_d_order\)\\/\\section($rnd_value_d_redundancy\)\\/mac_section/add_s"

    set force_path_zero1 /iir_tb/iir_filter_comp/\\zero_section(1)\\/mac_section/sum_s
    add_force $force_path_zero1 -radix hex 16x00000000 3000ns -cancel_after 4000ns
    set force_path_zero2 /iir_tb/iir_filter_comp/\\zero_section(2)\\/mac_section/sum_s
    add_force $force_path_zero2 -radix hex 16xffffffff 3100ns -cancel_after 4100ns
    set force_path_zero4 /iir_tb/iir_filter_comp/\\zero_section(4)\\/mac_section/sum_s 
    add_force $force_path_zero4 -radix hex 16x00000000 3200ns -cancel_after 4200ns
    set force_path_zero5 /iir_tb/iir_filter_comp/\\zero_section(5)\\/mac_section/sum_s
    add_force $force_path_zero5 -radix hex 16xffffffff 3400ns -cancel_after 4100ns
    set force_path_zero6 /iir_tb/iir_filter_comp/\\zero_section(6)\\/mac_section/sum_s
    add_force $force_path_zero6 -radix hex 16x00000000 3800ns -cancel_after 4200ns     
    set force_path_zero_init_i /iir_tb/iir_filter_comp/\\zero_section(6)\\/switch_section/init_i    
    add_force $force_path_zero_init_i 1 5500ns -cancel_after 6000ns   
        
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(1)\/mac_section/sum_s}}       
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(2)\/mac_section/sum_s}}
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(4)\/mac_section/sum_s}}    
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(5)\/mac_section/sum_s}}       
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(6)\/mac_section/sum_s}}
    add_wave {{/iir_tb/iir_filter_comp/\zero_section(6)\/switch_section/init_i}}
    
} else {
    puts "Unexpected redundancy value."
    set force_path /iir_tb/iir_filter_comp/\\all_section(1)\\/\\section(1)\\/mac_section/add_s
    add_force $force_path -radix hex 16x00000000 3000ns -cancel_after 5000ns
}

add_wave {{/iir_tb/iir_filter_comp/voter_zero/voter_i}}  
add_wave {{/iir_tb/iir_filter_comp/voter_zero/voter_o}}

set force_path_multiplier /iir_tb/iir_filter_comp/\\last_section(1)\\/mac_section/multiplier1/res_o
add_force $force_path_multiplier -radix hex 16xffffffff 10000ns -cancel_after 12000ns  
add_wave {{/iir_tb/iir_filter_comp/\last_section(1)\/mac_section/multiplier1/res_o}}
add_wave {{/iir_tb/iir_filter_comp/voter_last/voter_i}}  
add_wave {{/iir_tb/iir_filter_comp/voter_last/voter_o}}
   