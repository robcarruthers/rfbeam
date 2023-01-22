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

    def tdat
      request_frame_data(:tdat)

      sleep 0.1
      resp = read(16).unpack('a4LSssS')
      return { dist: resp[2], speed: resp[3], angle: resp[4], mag: resp[5] } unless resp[1].zero?
    end

    def ddat
      request_frame_data(:ddat)

      sleep 0.1
      resp = read(14).unpack('a4LC6')
      unless resp[1].zero?
        return
        {
          detection: DETECTION_FLAGS[:detection][resp[2]],
          micro_detection: DETECTION_FLAGS[:micro_detection][resp[3]],
          angle: DETECTION_FLAGS[:angle][resp[4]],
          direction: DETECTION_FLAGS[:direction][resp[5]],
          range: DETECTION_FLAGS[:range][resp[6]],
          speed: DETECTION_FLAGS[:speed][resp[7]],
        }
      end
    end

    private

    def init_radar
      command = ['INIT', 4, 0]
      @serial_port.write command.pack('a4LL') # 4 ASCII bytes, UINT32, UINT32
      check_response
    end

    def check_response
      sleep INIT_RESP_DELAY
      resp = @serial_port.read(9).unpack('a4LC') # 4 ASCII bytes, UINT32, UINT8
      raise Error, 'No valid response from Serial Port' if resp[2].nil?

      response_key = resp[2]
      return if response_key.zero? # Everything OK

      error_string = RESP_CODES[response_key].nil? ? 'Response unknown' : RESP_CODES[response_key]
      raise Error, "Initialisation Error: #{error_string}"
    end

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

    def request_frame_data(data_type)
      command = ['GNFD', 4, FRAME_DATA_TYPES[data_type]]
      write command.pack('a4LL')
      check_response
    end
  end
end
