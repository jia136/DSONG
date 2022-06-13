library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package arrays_package is
    type array_type is array (natural range <>) of std_logic_vector(31 downto 0);
end arrays_package;