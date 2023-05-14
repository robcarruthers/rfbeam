module RfBeam
  module KLD7
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
      raise ArgumentError, "Invalid arg: '#{speed}'" unless (0..3).cover?(speed)
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
      raise ArgumentError, "Invalid arg: '#{range}'" unless (0..3).cover?(range)
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
      raise ArgumentError, "Invalid arg: '#{offset}'" unless (10..60).cover?(offset)
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
      raise ArgumentError, "Invalid arg: '#{type}'" unless (0..2).cover?(type)
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
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..16).cover?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :visu, value, :uint32
    end
    alias visu= vibration_suppression=
    alias set_vibration_suppression vibration_suppression=
  end

  # -----------------
  # Range Threshold, 0 - 100% of Range setting, default = 10
  # -----------------
  def range_threshold
    query_parameter RADAR_PARAMETERS[:range_threshold].grps_index
  end

  def range_threshold=(value = 10)
    raise ArgumentError, "Invalid arg: '#{value}'" unless (0..100).cover?(value)
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
    raise ArgumentError, "Invalid arg: '#{value}'" unless (-90..90).cover?(value)
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
    raise ArgumentError, "Invalid arg: '#{value}'" unless (0..100).cover?(value)
    raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

    set_parameter :spth, value, :uint32
  end
  alias spth= angle_threshold=
  alias set_speed_threshold angle_threshold=
end
