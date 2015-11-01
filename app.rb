$:<<'lib'
require "serialport"
require 'active_support/all'
require "json"
require "app_monit"

require "smartmeter/measurement"

AppMonit::Config.api_key   = ENV["API_KEY"]
AppMonit::Config.env       = ENV["ENVIRONMENT"] || "development"
AppMonit::Config.log_level = ENV["LOGGING"] == 'error' ? Logger::ERROR : Logger::DEBUG
AppMonit::Config.async     = ENV["ASYNC"] != "false"

port_str  = ENV["USB_PORT"] || "/dev/slave"
baud_rate = 115200
data_bits = 8
stop_bits = 1
parity    = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

last_sample      = nil
last_measurement = nil

@running = true
trap(:INT) { @running = false }

while @running do
  lines = []
  while (line = sp.readline.chomp) do # see note 2
    lines << line
    break if line.start_with? "!"
  end

  measurement = Smartmeter::Measurement.parse(lines)

  if last_measurement
    if measurement.measured_at - last_sample.measured_at >= ENV["INTERVAL"].to_i
      p AppMonit::Event.create "measurement", measurement.stat(last_sample)
      last_sample = measurement
    end
  else
    last_sample = measurement
  end

  last_measurement = measurement
end

sp.close
