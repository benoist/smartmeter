require "serialport"
require 'active_support/all'

# sudo socat -d -d -d -d -lf /tmp/socat pty,link=/dev/master,raw,echo=0,user=benoist,group=staff pty,link=/dev/slave,raw,echo=0,user=benoist,group=staff

#params for serial port
port_str  = "/dev/master" #may be different for you
baud_rate = 115200
data_bits = 8
stop_bits = 1
parity    = SerialPort::NONE

port = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

usage_low        = 196.561
usage_normal     = 171.129
generated_normal = 98.424
generated_low    = 38.99
gas              = 203.061

loop do
  current_usage_low        = rand
  current_generated_low    = rand
  current_gas              = rand

  usage_low        += current_usage_low
  generated_low    += current_generated_low
  gas              += current_gas

  port.write("/XMX5LGBBFFB231250230\n")
  port.write("\n")
  port.write("1-3:0.2.8(40)\n")
  port.write("0-0:1.0.0(151101163812W)\n")
  port.write("0-0:96.1.1(4530303034303031363834323331343135)\n")
  port.write("1-0:1.8.1(000#{usage_low}*kWh)\n")
  port.write("1-0:2.8.1(000#{generated_low}*kWh)\n")
  port.write("1-0:1.8.2(000#{usage_normal}*kWh)\n")
  port.write("1-0:2.8.2(000#{generated_normal}*kWh)\n")
  port.write("0-0:96.14.0(0002)\n")
  port.write("1-0:1.7.0(0#{current_usage_low}*kW)\n")
  port.write("1-0:2.7.0(00.000*kW)\n")
  port.write("0-0:17.0.0(999.9*kW)\n")
  port.write("0-0:96.3.10(1)\n")
  port.write("0-0:96.7.21(00001)\n")
  port.write("0-0:96.7.9(00000)\n")
  port.write("1-0:99.97.0(0)(0-0:96.7.19)\n")
  port.write("1-0:32.32.0(00000)\n")
  port.write("1-0:32.36.0(00000)\n")
  port.write("0-0:96.13.1()\n")
  port.write("0-0:96.13.0()\n")
  port.write("1-0:31.7.0(002*A)\n")
  port.write("1-0:21.7.0(00.209*kW)\n")
  port.write("1-0:22.7.0(00.000*kW)\n")
  port.write("0-1:24.1.0(003)\n")
  port.write("0-1:96.1.0(4730303136353631323131333837313134)\n")
  port.write("0-1:24.2.1(150909190000W)(00#{gas}*m3)\n")
  port.write("0-1:24.4.0(1)\n")
  port.write("!\n")

  sleep(5)
end
