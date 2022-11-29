# frozen_string_literal: true

require 'rubyserial'
require 'rfbeam/k_ld7'
require_relative 'rfbeam/version'

module Rfbeam
  class Error < StandardError
  end

  class KLD7
    include Rfbeam::K_LD7
  end
end
