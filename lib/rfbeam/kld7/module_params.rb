# frozen_string_literal: true

module Rfbeam
  module KLD7
    # -----------------
    # Software Version, 'K-LD7_APP-RFB-XXXX'
    # -----------------
    def sw_version
      query_parameter RADAR_PARAMETERS[:sw_version].grps_index
    end

    # -----------------
    # Digital output 1, 0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default = 0
    # -----------------
    def digital_output1
      query_parameter RADAR_PARAMETERS[:digital_output1].grps_index
    end

    def digital_output1=(value = 0)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..4).cover?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :dig1, value, :uint32
    end
    alias dig1= digital_output1=
    alias set_digital_output1 digital_output1=

    # -----------------
    # Digital output 2, 0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default = 1
    # -----------------
    def digital_output2
      query_parameter RADAR_PARAMETERS[:digital_output2].grps_index
    end

    def digital_output2=(value = 1)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..4).cover?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :dig2, value, :uint32
    end
    alias dig2= digital_output2=
    alias set_digital_output2 digital_output2=

    # -----------------
    # Digital output 3, 0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default = 2
    # -----------------
    def digital_output3
      query_parameter RADAR_PARAMETERS[:digital_output3].grps_index
    end

    def digital_output3=(value = 2)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..4).cover?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :dig3, value, :uint32
    end
    alias dig3= digital_output3=
    alias set_digital_output3 digital_output3=

    # -----------------
    # Hold Time, 1 - 7200s, default = 1
    # -----------------
    def hold_time
      query_parameter RADAR_PARAMETERS[:hold_time].grps_index
    end

    def hold_time=(time = 1)
      raise ArgumentError, "Invalid arg: '#{time}'" unless (1..7200).cover?(time)
      raise ArgumentError, 'Expected an Integer' unless time.is_a?(Integer)

      set_parameter :hold, time, :uint32
    end
    alias hold= hold_time=
    alias set_hold_time hold_time=

    private

    def query_parameter(index)
      data = grps
      data[index]
    end

    def set_parameter(header, value, return_type = :uint32)
      char =
        case return_type
        when :int32
          'l'
        else
          'L'
        end
      command = [header.upcase.to_s, 4, value]
      write command.pack("a4L#{char}")
      check_response
    end
  end
end
