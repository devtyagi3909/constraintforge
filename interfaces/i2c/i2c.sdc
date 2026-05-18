# ---
# I2C CONSTRAINTS  —  Intel Quartus Prime (.sdc)
# ---
# I2C is open-drain asynchronous. Set false path on both SCL and SDA.
# Pin assignments belong in the .qsf file.
# ---

set_false_path -from [get_ports {i2c_scl}]
set_false_path -from [get_ports {i2c_sda}]
set_false_path -to   [get_ports {i2c_scl}]
set_false_path -to   [get_ports {i2c_sda}]
