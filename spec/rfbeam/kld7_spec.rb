# frozen_string_literal: true
# rubocop:disable all

require 'minitest/autorun'
require_relative '../../lib/rfbeam'
require 'test_helper'

describe RfBeam do
  describe 'kld7' do
    before do
      path = '/dev/ttyUSB0'

      @serial_port = Minitest::Mock.new

      Serial.stub :new, @serial_port do
        @radar = RfBeam::Kld7.new(path)
      end
    end

    it 'returns nil when not connected' do
      @radar.stub :connected?, false do
        assert_nil @radar.read(10)
      end
    end

    it 'reads specified number of bytes when connected' do
      bytes_to_read = 10
      expected_data = '1234567890'

      @serial_port.expect :read, expected_data, [bytes_to_read]

      @radar.stub :connected?, true do
        expect(@radar.read(bytes_to_read)).must_equal expected_data
        @serial_port.verify
      end
    end

    it 'reads data from serial port' do
      expected_data = 'Some radar data'
      @serial_port.expect :read, expected_data, [10]

      @radar.stub :connected?, true do
        assert_equal expected_data, @radar.read(10)
        @serial_port.verify
      end
    end

    it 'writes data to serial port' do
      data_to_write = 'Some radar data'
      @serial_port.expect :write, nil, [data_to_write]

      @radar.stub :connected?, true do
        @radar.write(data_to_write)
        @serial_port.verify
      end
    end
  end
end
