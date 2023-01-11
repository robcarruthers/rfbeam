module RfBeam
  module KLD7
    require 'rubyserial'
    require 'timeout'

    class Error < StandardError
    end

    attr_reader :serial_port
    BAUDE_RATES = { 0 => 115_200, 1 => 460_800, 2 => 921_600, 3 => 2_000_000, 4 => 3_000_000 }.freeze

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

    private

    INIT_RESP_DELAY = 0.05
    def open_serial_port(path, baude_rate, data_bits, parity, stop_bits)
      @serial_port = Serial.new(path, baude_rate, data_bits, parity, stop_bits)
      command = ['INIT', 4, 0]

      @serial_port.write command.pack('a4LL') # 4 ASCII bytes, UINT32, UINT32
      sleep INIT_RESP_DELAY
      resp = read(9).unpack('a4LC') # 4 ASCII bytes, UINT32, UINT8
      return if resp[2].zero?

      raise Error, 'Initialisation Error for K-LD7'
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
  end
end
