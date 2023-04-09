# frozen_string_literal: true

module RfBeam
  module Kld7
    # -----------------
    # Software Version, 'K-LD7_APP-RFB-XXXX'
    # -----------------
    def sw_version
      query_parameter RADAR_PARAMETERS[:sw_version].grps_index
    end

    # -----------------
    # Base Frequency, 0 = low, 1 = middle (default), 2 = high
    # -----------------
    def base_frequency
      query_parameter RADAR_PARAMETERS[:base_frequency].grps_index
    end
    alias rbfr base_frequency

    def base_frequency=(frequency = 1)
      value =
        case frequency
        when 0, :low, 'low'
          0
        when 1, :middle, 'middle'
          1
        when 2, :high, 'high'
          2
        else
          raise ArgumentError, "Invalid arg: '#{frequency}'"
        end
      set_parameter(:rbfr, value, :uint32)
    end

    alias set_base_frequency base_frequency=
    alias rbfr= base_frequency=

    # -----------------
    # Maximum Speed, 0 = 12.5km/h, 1 = 25km/h (default), 2 = 50km/h, 3 = 100km/h
    # -----------------
    def max_speed
      query_parameter(RADAR_PARAMETERS[:max_speed].grps_index)
    end

    def max_speed=(speed = 1)
      raise ArgumentError, "Invalid arg: '#{speed}'" unless (0..3).include?(speed)
      raise ArgumentError, 'Expected an Integer' unless speed.is_a?(Integer)

      set_parameter :rspi, speed, :uint32
    end

    alias set_max_speed max_speed=
    alias rspi max_speed=

    # -----------------
    # Maximum Range, 0 = 5m, 1 = 10m (default), 2 = 30m, 3 = 100m
    # -----------------
    def max_range
      query_parameter(RADAR_PARAMETERS[:max_range].grps_index)
    end

    def max_range=(range = 1)
      raise ArgumentError, "Invalid arg: '#{range}'" unless (0..3).include?(range)
      raise ArgumentError, 'Expected an Integer' unless range.is_a?(Integer)

      set_parameter :rrai, range, :uint32
    end

    alias rrai= max_range=
    alias set_max_range max_range=

    # -----------------
    # Threshold Offset, 10 - 60db, (default = 30)
    # -----------------
    def threshold_offset
      query_parameter RADAR_PARAMETERS[:threshold_offset].grps_index
    end

    def threshold_offset=(offset = 30)
      raise ArgumentError, "Invalid arg: '#{offset}'" unless (10..60).include?(offset)
      raise ArgumentError, 'Expected an Integer' unless offset.is_a?(Integer)

      set_parameter :thof, offset, :uint32
    end

    alias thof= threshold_offset=
    alias set_threshold_offset threshold_offset=

    # -----------------
    # Tracking filter type, 0 = Standard (Default), 1 = Fast Tracking, 2 = Long visibility
    # -----------------
    def tracking_filter
      query_parameter RADAR_PARAMETERS[:tracking_filter].grps_index
    end

    def tracking_filter=(type = 0)
      raise ArgumentError, "Invalid arg: '#{type}'" unless (0..2).include?(type)
      raise ArgumentError, 'Expected an Integer' unless type.is_a?(Integer)

      set_parameter :trft, type, :uint32
    end
    alias trtf= tracking_filter=
    alias set_tracking_filter tracking_filter=

    # -----------------
    # Vibration suppression, 0 - 16, 0 = No Suppression, 16 = High Suppression, default = 2
    # -----------------
    def vibration_suppression
      query_parameter RADAR_PARAMETERS[:vibration_suppression].grps_index
    end

    def vibration_suppression=(value = 2)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..16).include?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :visu, value, :uint32
    end
    alias visu= vibration_suppression=
    alias set_vibration_suppression vibration_suppression=

    # -----------------
    # Minimum Detection distance, 0 - 100% of Range setting, default = 0
    # -----------------
    def min_detection_distance
      query_parameter RADAR_PARAMETERS[:min_detection_distance].grps_index
    end

    def min_detection_distance=(value = 0)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..100).include?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :mira, value, :uint32
    end
    alias mira= min_detection_distance=
    alias set_min_detection_distance min_detection_distance=

    # -----------------
    # Maximum Detection distance, 0 - 100% of Range setting, default = 50
    # -----------------
    def max_detection_distance
      query_parameter RADAR_PARAMETERS[:min_detection_distance].grps_index
    end

    def max_detection_distance=(value = 50)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..100).include?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :mara, value, :uint32
    end
    alias mara= max_detection_distance=
    alias set_max_detection_distance max_detection_distance=

    # -----------------
    # Minimum Detection Angle, -90° - 90°, default = -90
    # -----------------
    def min_detection_angle
      query_parameter RADAR_PARAMETERS[:min_detection_angle].grps_index
    end

    def min_detection_angle=(angle = -90)
      raise ArgumentError, "Invalid arg: '#{angle}'" unless (-90..90).include?(angle)
      raise ArgumentError, 'Expected an Integer' unless angle.is_a?(Integer)

      set_parameter :mian, angle, :int32
    end
    alias mian= min_detection_angle=
    alias set_min_detection_angle min_detection_angle=

    # -----------------
    # Maximum Detection Angle, -90° - 90°, default = 90
    # -----------------
    def max_detection_angleq
      query_parameter RADAR_PARAMETERS[:max_detection_angle].grps_index
    end

    def max_detection_angle=(angle = 90)
      raise ArgumentError, "Invalid arg: '#{angle}'" unless (-90..90).include?(angle)
      raise ArgumentError, 'Expected an Integer' unless angle.is_a?(Integer)

      set_parameter :maan, angle, :int32
    end
    alias maan= max_detection_angle=
    alias set_max_detection_angle max_detection_angle=

    # -----------------
    # Minimum Detection Speed, 0 - 100% of Speed setting, default = 0
    # -----------------
    def min_detection_speed
      query_parameter RADAR_PARAMETERS[:min_detection_angle].grps_index
    end

    def min_detection_speed=(speed = 0)
      raise ArgumentError, "Invalid arg: '#{speed}'" unless (0..100).include?(speed)
      raise ArgumentError, 'Expected an Integer' unless speed.is_a?(Integer)

      set_parameter :misp, speed, :uint32
    end
    alias misp= min_detection_speed=
    alias set_min_detection_speed min_detection_speed=

    # -----------------
    # Maximum Detection Speed, 0 - 100% of Speed setting, default = 100
    # -----------------
    def max_detection_speed
      query_parameter RADAR_PARAMETERS[:max_detection_speed].grps_index
    end

    def max_detection_speed=(speed = 100)
      raise ArgumentError, "Invalid arg: '#{speed}'" unless (0..100).include?(speed)
      raise ArgumentError, 'Expected an Integer' unless speed.is_a?(Integer)

      set_parameter :masp, speed, :uint32
    end
    alias masp= max_detection_speed=
    alias set_max_detection_speed max_detection_speed=

    # -----------------
    # Detection Direction, 0 = Receding, 1 = Approaching, 2 = Both (default)
    # -----------------
    def detection_direction
      query_parameter RADAR_PARAMETERS[:detection_direction].grps_index
    end

    def detection_direction=(direction = 2)
      raise ArgumentError, "Invalid arg: '#{direction}'" unless (0..2).include?(direction)
      raise ArgumentError, 'Expected an Integer' unless direction.is_a?(Integer)

      set_parameter :dedi, direction, :uint32
    end
    alias dedi= detection_direction=
    alias set_detection_direction detection_direction=

    # -----------------
    # Range Threshold, 0 - 100% of Range setting, default = 10
    # -----------------
    def range_threshold
      query_parameter RADAR_PARAMETERS[:range_threshold].grps_index
    end

    def range_threshold=(value = 10)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..100).include?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :rath, value, :uint32
    end
    alias rath= range_threshold=
    alias set_range_threshold range_threshold=

    # -----------------
    # Angle Threshold, -90° to 90°, default = 0
    # -----------------
    def angle_threshold
      query_parameter RADAR_PARAMETERS[:angle_threshold].grps_index
    end

    def angle_threshold=(value = 0)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (-90..90).include?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :anth, value, :int32
    end
    alias anth= angle_threshold=
    alias set_angle_threshold angle_threshold=

    # -----------------
    # Speed Threshold, 0 - 100% of speed setting, default = 50
    # -----------------
    def speed_threshold
      query_parameter RADAR_PARAMETERS[:speed_threshold].grps_index
    end

    def speed_threshold=(value = 50)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..100).include?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :spth, value, :uint32
    end
    alias spth= angle_threshold=
    alias set_speed_threshold angle_threshold=

    # -----------------
    # Digital output 1, 0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default = 0
    # -----------------
    def digital_output1
      query_parameter RADAR_PARAMETERS[:digital_output1].grps_index
    end

    def digital_output1=(value = 0)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..4).include?(value)
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
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..4).include?(value)
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
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..4).include?(value)
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
      raise ArgumentError, "Invalid arg: '#{time}'" unless (1..7200).include?(time)
      raise ArgumentError, 'Expected an Integer' unless time.is_a?(Integer)

      set_parameter :hold, time, :uint32
    end
    alias hold= hold_time=
    alias set_hold_time hold_time=

    # -----------------
    # Micro Detection retrigger, 0 = Off (default), 1 = Retrigger
    # -----------------
    def micro_detection_retrigger
      query_parameter RADAR_PARAMETERS[:set_micro_detection_retrigger].grps_index
    end

    def micro_detection_retrigger=(value = 0)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..1).include?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :mide, value, :uint32
    end
    alias mide= micro_detection_retrigger=
    alias set_micro_detection_retrigger micro_detection_retrigger=

    # -----------------
    # Micro Detection sensitivity, 0 - 9, 0 = Min, 9 = Max, default = 4
    # -----------------
    def micro_detection_sensitivity
      query_parameter RADAR_PARAMETERS[:micro_detection_sensitivity].grps_index
    end

    def micro_detection_sensitivity=(value = 4)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..9).include?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :mids, value, :uint32
    end
    alias mids= micro_detection_sensitivity=
    alias set_micro_detection_sensitivity micro_detection_sensitivity=

    private

    def query_parameter(index)
      data = grps
      data[index]
    end

    def set_parameter(header, value, return_type = :uint32)
      return_type =
        case return_type
        when :uint32
          'L'
        when :int32
          'l'
        else
          'L'
        end
      command = [header.upcase.to_s, 4, value]
      write command.pack("a4L#{return_type}")
      check_response
    end
  end
end
