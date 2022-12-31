# frozen_string_literal: true

require 'rfbeam/k_ld7'
require_relative 'rfbeam/version'

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
