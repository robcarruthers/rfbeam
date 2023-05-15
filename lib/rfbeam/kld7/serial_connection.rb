module RfBeam
  module KLD7
    require 'rubyserial'
    require 'timeout'

    class Error < StandardError
    end

    attr_reader :serial_port

    def initialize(path, baude_rate = 0)
      baude_rate = check_speed(baude_rate)
      data_bits = 8
      parity = :even
      stop_bits = 1
      open_serial_port(path, baude_rate, data_bits, parity, stop_bits)

      yield self if block_given?
    end

    def close
      return unless connected?

      @serial_port.close
      @serial_port = nil
      @serial_port.nil?
    end

    def read(bytes)
      return unless connected?

      @serial_port.read(bytes)
    end

    def write(string)
      return unless connected?

      @serial_port.write(string)
      sleep 0.1
    end

    def init_radar
      command = ['INIT', 4, 0]
      @serial_port.write command.pack('a4LL')
      check_response
    end

    private

    def open_serial_port(path, baude_rate, data_bits, parity, stop_bits)
      @serial_port = Serial.new(path, baude_rate, data_bits, parity, stop_bits)
    end

    def connected?
      raise Error, 'ConnectionError: No open Serial device connections.' if @serial_port.closed?

      true
    end

    def flush
      return unless connected?

      loop until serial_port.getbyte.nil?
    end

    def check_speed(baude)
      if BAUDE_RATES.value? baude
        baude
      elsif BAUDE_RATES.key? baude
        BAUDE_RATES[baude]
      else
        115_200
      end
    end

    def check_response
      sleep RESPONSE_DELAY
      resp = @serial_port.read(9).unpack('a4LC')
      raise Error, 'No valid response from Serial Port' if resp[2].nil?

      resp_code = resp[2]
      index_range = 1..RESP_CODES.size

      raise Error, "Radar response Error: #{RESP_CODES[resp_code]}" if index_range.include?(resp_code)
      true
    end
  end
end
