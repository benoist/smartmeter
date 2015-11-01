module Smartmeter
  class Measurement
    class << self
      def point(identifier, key, parser)
        @points      ||= {}
        @points[key] = [identifier, parser]
        attr_accessor identifier
      end

      def parse(rows)
        measurement = new
        rows.each do |row|
          key                = row.slice!(/[^(]+/)
          identifier, parser = @points[key]
          if identifier
            measurement.send("#{identifier}=", parser.call(row))
          end
        end
        measurement
      end
    end

    point :meter_id, '0-0:96.1.1', ->(value) { value.scan(/\d+/).first.to_s }
    point :measured_at, '0-0:1.0.0', ->(value) { Time.strptime(value.scan(/\d+S/).first, "%y%m%d%H%M%SS") }

    point :total_usage_low, '1-0:1.8.1', ->(value) { value.scan(/\d+\.\d+/).first.to_f }
    point :total_usage_normal, '1-0:1.8.2', ->(value) { value.scan(/\d+\.\d+/).first.to_f }

    point :total_generated_low, '1-0:2.8.1', ->(value) { value.scan(/\d+\.\d+/).first.to_f }
    point :total_generated_normal, '1-0:2.8.2', ->(value) { value.scan(/\d+\.\d+/).first.to_f }

    point :current_tariff, '0-0:96.14.0', ->(value) { value.scan(/\d+/).first.to_i == 1 ? :low : :high }
    point :current_usage, '1-0:1.7.0', ->(value) { value.scan(/\d+\.\d+/).first.to_f }
    point :current_generation, '1-0:2.7.0', ->(value) { value.scan(/\d+\.\d+/).first.to_f }

    point :total_gas_usage, '0-1:24.2.1', ->(value) { value.scan(/\d+\.\d+/).first.to_f }

    def diff(other)
      {
          usage_low:        total_usage_low - other.total_usage_low,
          usage_normal:     total_usage_normal - other.total_usage_normal,
          gas_usage:        total_gas_usage - other.total_gas_usage,
          generated_low:    total_generated_low - other.total_generated_low,
          generated_normal: total_generated_normal - other.total_generated_normal
      }
    end

    def stat(other)
      {
          current_usage: current_usage,
          current_generation: current_generation,
          total_gas_usage: total_gas_usage,
          total_generated_low: total_generated_low,
          total_generated_normal: total_generated_normal,
          total_usage_low: total_usage_low,
          total_usage_normal: total_usage_normal,
      }.merge(diff(other))
    end
  end
end
