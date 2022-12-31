module RfBeam::KLD7
  require 'rubyserial'
  require 'timeout'

  class Error < StandardError
  end

  attr_reader :serial_port

  def initialize(path, baude_rate = 115_200, data_bit = 8, parity = :even, stop_bits = 1)
    open_serial_port(path, baude_rate, data_bit, parity, stop_bits)

    yield self if block_given?
  end

  def close
    return unless connected?

    @serial_port.close
    @serial_port = nil
    @serial_port.nil?
  end

  def write(string)
    return unless connected?

    @serial_port.write(string)
    sleep 0.1
  end

  def read(bytes)
    return unless connected?

    @serial_port.read(bytes)
  end
  #
  #   def readline
  #     return unless connected?
  #
  #     t = Timeout.timeout(1, Timeout::Error, 'No response from device') { getline }
  #   end
  #
  #   def sr(register = nil)
  #     write 'SR'
  #     write '++read eoi'
  #     array = []
  #     24.times { array << readline }
  #     array.map! { |byte| '%08b' % byte.to_i }
  #     register.nil? ? array : array[register - 1]
  #   end
  #

  private

  def open_serial_port(path, baude_rate, data_bit, parity, stop_bits)
    @serial_port = Serial.new(path, baude_rate, data_bit, parity, stop_bits)
    init_command = ['INIT', 4, 0]

    write init_command.pack('a4LL')
    resp = read(9).unpack('a4LC')
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
  #
  #   # This method will block until the EOL terminator is received
  #   # The lower level gets method is pure ruby, so can be safely used with Timeout.
  #   def getline
  #     return unless connected?
  #
  #     @serial_port.gets(EOL).chomp
  #   end
  #
  #   def device_query(command)
  #     flush
  #     write(command)
  #     readline
  #   end
end
