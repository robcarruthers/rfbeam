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

    it 'reads specified number of bytes when connected' do
      bytes_to_read = 10
      expected_data = '1234567890'

      @serial_port.expect :read, expected_data, [bytes_to_read]

      @radar.stub :connected?, true do
        expect(@radar.read(bytes_to_read)).must_equal expected_data
        @serial_port.verify
      end
    end

    # def test_that_radar_returns_nil_when_not_connected
    #   bytes_to_read = 10

    #   @serial_port.expect :connected?, false

    #   assert_nil @radar.read(bytes_to_read)
    #   @serial_port.verify
    # end

    # def test_that_radar_reads_data_from_serial_port
    #   expected_data = 'Some radar data'
    #   @serial_port.expect :read, expected_data

    #   assert_equal expected_data, @radar.read
    #   @serial_port.verify
    # end

    # def test_that_radar_sends_data_to_serial_port
    #   data_to_write = 'Some data to write'
    #   @serial_port.expect :write, nil, [data_to_write]

    #   @radar.write(data_to_write)
    #   @serial_port.verify
    # end
  end
end
