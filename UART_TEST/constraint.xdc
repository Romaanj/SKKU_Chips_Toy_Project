create_clock -period 10 -name clk [get_ports clk]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN R4}     [get_ports clk]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN U7}     [get_ports rst]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN N13}    [get_ports RX]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN N14}    [get_ports TX]