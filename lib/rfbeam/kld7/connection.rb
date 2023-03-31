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
      init_radar if connected?

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

    private

    def open_serial_port(path, baude_rate, data_bits, parity, stop_bits)
      @serial_port = Serial.new(path, baude_rate, data_bits, parity, stop_bits)
    end

    def connected?
      raise Error, 'ConnectionError: No open Serial device connections.' if @serial_port.nil?

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

    def init_radar
      command = ['INIT', 4, 0]
      @serial_port.write command.pack('a4LL') # 4 ASCII bytes, UINT32, UINT32
      check_response
    end

    def check_response
      sleep RESP_DELAY
      resp = @serial_port.read(9).unpack('a4LC') # 4 ASCII bytes, UINT32, UINT8
      raise Error, 'No valid response from Serial Port' if resp[2].nil?

      response_key = resp[2]
      return response_key.zero? # Everything OK

      error_string = RESP_CODES[response_key].nil? ? 'Response unknown' : RESP_CODES[response_key]
      raise Error, "Radar response Error: #{error_string}"
    end
  end
end
