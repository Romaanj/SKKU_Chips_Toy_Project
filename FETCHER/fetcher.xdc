create_clock -period 10 -name clk [get_ports clk]

set_property	-dict	{PACKAGE_PIN	R4		IOSTANDARD	LVCMOS33}	[get_ports	clk		]
set_property	-dict	{PACKAGE_PIN	U7		IOSTANDARD	LVCMOS33}	[get_ports	rst_n	]