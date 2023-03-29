module RfBeam
  module KLD7
  
    def detection?
      data = ddat
      (data[2] == 1)
    end
    
    def config
      puts formatted_grps(grps)
    end

    # Get the radar parameter structure
    def grps
      command = ['GRPS', 0]
      write command.pack('a4L')
      check_response
      read(50).unpack('a4LA19C8c2C4cCCCCSCC')
    end
    
    # Base Frequency, 0 = low, 1 = middle (default), 2 = high
    def set_base_frequency(frequency = 1)
      set_parameter(:rbfr, frequency, :uint8)
    end
    alias_method :rbfr, :set_base_frequency
    
    # Maximum Speed, 0 = 12.5km/h, 1 = 25km/h (default), 2 = 50km/h, 3 = 100km/h
    def set_max_speed(speed = 1)
      set_parameter :rspi, speed, :uint8
    end
    alias_method :rspi, :set_max_speed
    
    # Maximum Range, 0 = 5m, 1 = 10m (default), 2 = 30m, 3 = 100m
    def set_max_range(range = 1)
      set_parameter :rrai, range, :uint8
    end
    alias_method :rrai, :set_max_range
    
    # Threshold Offset, 10 - 60db, (default = 30)
    def set_threshold_offset(offset = 30)
      range = 10..60
      return false unless range.include?(offset)
      
      set_parameter :thof, offset, :uint8
    end
    alias_method :thof, :set_threshold_offset
    
    # Tracking filter type, 0 = Standard (Default), 1 = Fast Tracking, 2 = Long visibility
    def set_tracking_filter(type = 0)
        set_parameter :trft, type, :uint8
    end
    alias_method :trtf, :set_tracking_filter
    
    # Vibration suppression, 0 - 16, 0 = No Suppression, 16 = High Suppression, default = 2
    def set_vibration_suppression(value = 2)
      set_parameter :visu, value, :uint8  
    end
    alias_method :visu, :set_vibration_suppression
    
    # Minimum Detection distance, 0 - 100% of Range setting, default = 0
    def set_min_detection_distance(value = 0)
      set_parameter :mira, value, :uint8
    end
    alias_method :mira, :set_min_detection_distance
    
    # Maximum Detection distance, 0 - 100% of Range setting, default = 50
    def set_max_detection_distance(value = 50)
      set_parameter :mara, value, :uint8
    end
    alias_method :mara, :set_max_detection_distance
    
    # Minimum Detection Angle, -90° - 90°, default = -90
    def set_min_detection_angle(angle = -90)
      set_parameter :mian, angle, :int8
    end
    alias_method :mian, :set_min_detection_distance
    
    # Maximum Detection Angle, -90° - 90°, default = 90
    def set_min_detection_angle(angle = 90)
      set_parameter :maan, angle, :int8
    end
    alias_method :maan, :set_min_detection_angle
    
    # Minimum Detection Speed, 0 - 100% of Speed setting, default = 0
    def set_min_detection_speed(speed = 0)
      set_parameter :misp, speed, :uint8
    end
    alias_method :misp, :set_min_detection_speed
    
    # Maximum Detection Speed, 0 - 100% of Speed setting, default = 100
    def set_max_detection_speed(speed = 100)
      set_parameter :masp, speed, :uint8
    end
    alias_method :masp, :set_max_detection_speed
    
    # Detection Direction, 0 = Receding, 1 = Approaching, 2 = Both (default)
    def set_detection_direction(direction = 2)
      set_parameter :dedi, direction, :uint8
    end
    alias_method :dedi, :set_detection_direction
    
    # Range Threshold, 0 - 100% of Range setting, default = 10
    def set_range_threshold(value = 10)
      range = 0..100
      return false unless range.include?(value)
      
      set_parameter :rath, value, :uint8
    end
    alias_method :rath, :set_range_threshold
    
    # Angle Threshold, -90° to 90°, default = 0
    def set_range_threshold(value = 0)
      range = -90..90
      return false unless range.include?(value)
      
      set_parameter :anth, value, :int8
    end
    alias_method :anth, :set_range_threshold
    
    # Speed Threshold, 0 - 100% of speed setting, default = 50
    def set_angle_threshold(value = 50)
      range = 0..100
      return false unless range.include?(value)
      
      set_parameter :spth, value, :uint8
    end
    alias_method :spth, :set_angle_threshold
    
    # Digital output 1, 0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default = 0
    def set_dio_1(value = 0)
      range = 0..4
      return false unless range.include?(value)
      
      set_parameter :dig1, value, :uint8
    end
    alias_method :dig1, :set_dio_1
    
    # Digital output 2, 0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default = 1
    def set_dio_2(value = 1)
      range = 0..4
      return false unless range.include?(value)
      
      set_parameter :dig2, value, :uint8
    end
    alias_method :dig2, :set_dio_2
    
    # Digital output 3, 0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default = 2
    def set_dio_3(value = 2)
      range = 0..4
      return false unless range.include?(value)
      
      set_parameter :dig3, value, :uint8
    end
    alias_method :dig3, :set_dio_3
    
    # Hold Time, 1 - 7200s, default = 1
    def set_hold_time(time = 1)
      range = 1..7200
      return false unless range.include?(time)
      
      set_parameter :hold, time, :uint16
    end
    alias_method :hold, :set_hold_time
    
    # Micro Detection retrigger, 0 = Off (default), 1 = Retrigger
    def set_micro_detection_retrigger(value = 0)
      return false unless (value == 0 || value == 1)
      
      set_parameter :mide, value, :uint8
    end
    alias_method :mide, :set_micro_detection_retrigger
    
    # Micro Detection sensitivity, 0 - 9, 0 = Min, 9 = Max, default = 4
    def set_micro_detection_sensitivty(value = 4)
      range = 0..9
      return false unless range.include?(value)
      
      set_parameter :mids, value, :uint8
    end
    alias_method :mids, :set_micro_detection_sensitivty

    private
    
    def set_parameter(header, value, return_type = :uint8)
      return_type =
        case return_type
          when :uint8
          'L'
          when :int8
          'c'
          when :uint16
          'S'
          else
          'L'
        end
      command = [header.upcase.to_s, 4, value]
      write command.pack("a4L#{return_type}")
      check_response
    end
    
    def formatted_grps(data)
      output = "\n"
      output << "Software Version: #{data[2]}\n"
      output << "Base Frequency: #{PARAMETER_STRUCTURE[:base_frequency][data[3]]}\n"
      output << "Max Speed: #{PARAMETER_STRUCTURE[:max_speed][data[4]]}\n"
      output << "Max Range: #{PARAMETER_STRUCTURE[:max_range][data[5]]}\n"
      output << "Threshold offset: #{data[6]}db\n"
      output << "Tracking Filter Type: #{PARAMETER_STRUCTURE[:tracking_filter_type][data[7]]}\n"
      output << "Vibration Suppression: #{data[8]} , (#{PARAMETER_STRUCTURE[:vibration_suppression]})\n"
      output << "Minimum Detection Distance: #{data[9]} , (#{PARAMETER_STRUCTURE[:min_detection_distance]})\n"
      output << "Maximum Detection Distance: #{data[10]} , (#{PARAMETER_STRUCTURE[:max_detection_distance]})\n"
      output << "Minimum Detection Angle: #{data[11]}° , (#{PARAMETER_STRUCTURE[:min_detection_angle]})\n"
      output << "Maximum Detection Angle: #{data[12]}° , (#{PARAMETER_STRUCTURE[:max_detection_angle]})\n"
      output << "Minimum Detection Speed: #{data[13]} , (#{PARAMETER_STRUCTURE[:min_detection_speed]})\n"
      output << "Maximum Detection Speed: #{data[14]} , (#{PARAMETER_STRUCTURE[:max_detection_speed]})\n"
      output << "Detection Direction: #{PARAMETER_STRUCTURE[:detection_direction][data[15]]}\n"
      output << "Range Threshold: #{data[16]}%, (#{PARAMETER_STRUCTURE[:range_threshold]})\n"
      output << "Angle Threshold: #{data[17]}°, (#{PARAMETER_STRUCTURE[:angle_threshold]})\n"
      output << "Speed Threshold: #{data[18]}%, (#{PARAMETER_STRUCTURE[:speed_threshold]})\n"
      output << "Digital output 1: #{PARAMETER_STRUCTURE[:digital_output_1][data[19]]}\n"
      output << "Digital output 2: #{PARAMETER_STRUCTURE[:digital_output_2][data[20]]}\n"
      output << "Digital output 3: #{PARAMETER_STRUCTURE[:digital_output_3][data[21]]}\n"
      output << "Hold time: #{data[22]}sec\n"
      output << "Micro Detection Retrigger: #{PARAMETER_STRUCTURE[:micro_detection_trigger][data[23]]}\n"
      output << "Micro Detection Sensitivity: #{data[24]} (#{PARAMETER_STRUCTURE[:micro_detection_sensitivity]})"
      
      output
    end
  end
end
