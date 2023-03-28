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
      set_parameter :rrai, range, :unit8
    end
    alias_method :rrai, :set_max_range
    
    # Threshold Offset, 10 - 60db, (default = 30)
    def set_threshold_offset(offset = 30)
      range = 10..60
      return false unless range.include?(offset)
      
      set_parameter :thof, range, :unit8
    end
    alias_method :thof, :set_threshold_offset

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
      output << "Maximum Detection Angle: #{data[12]}° , (#{PARAMETER_STRUCTURE[:max_detection_distance]})\n"
      output << "Maximum Detection Speed: #{data[13]} , (#{PARAMETER_STRUCTURE[:min_detection_speed]})\n"
      output << "Maximum Detection Speed: #{data[14]} , (#{PARAMETER_STRUCTURE[:max_detection_speed]})\n"
      output << "Detection Direction: #{data[15]}"
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
