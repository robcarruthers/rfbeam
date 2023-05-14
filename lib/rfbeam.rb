# frozen_string_literal: true

require 'rfbeam/kld7/detection_params'
require 'rfbeam/kld7/operation_params'
require 'rfbeam/kld7/module_params'
require 'rfbeam/kld7/radar_messages'
require 'rfbeam/kld7/serial_connection'
require 'rfbeam/kld7/constants'
require 'rfbeam/kld7/streamer'
require 'rfbeam/version'
require 'rfbeam/cli'

module RfBeam
  class Error < StandardError
  end

  class K_ld7
    include RfBeam::KLD7
  end

  def self.connected
    path_str, dir =
      if RubySerial::ON_LINUX
        %w[ttyUSB /dev/]
      elsif RubySerial::ON_WINDOWS
        ['TODO: Implement find device for Windows', 'You lazy bugger']
      else
        %w[tty.usbserial /dev/]
      end

    Dir.glob("#{dir}#{path_str}*")
  end
end
