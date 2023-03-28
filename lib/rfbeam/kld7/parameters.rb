module RfBeam
  module KLD7
    def detection?
      data = ddat
      (data[2] == 1)
    end

    def grps
      command = ['GRPS', 0]
      write command.pack('a4L')
      check_response
      resp = read(50).unpack('a4LA19C8c2C4cCCCCSCC')
      resp
    end
    
    def config
      puts formatted_grps(grps)
    end

    private
    
    def formatted_grps(data)
      output = '\n'
      output << "Software Version: #{data[2]}\n"
      output << "Base Frequency: #{PARAMETER_STRUCTURE[:base_frequency][data[3]]}\n"
      output << "Max Speed: #{PARAMETER_STRUCTURE[:max_speed][data[4]]}\n"
      output << "Max Range: #{PARAMETER_STRUCTURE[:max_range][data[5]]}\n"
      output << "Threshold offset: #{data[6]}db"
      output << "Tracking Filter Type: #{PARAMETER_STRUCTURE[:tracking_filter_type][data[7]]}"
      output << "Vibration Suppression: #{data[8]} , (#{PARAMETER_STRUCTURE[:vibration_suppression]})"
      output << "Minimum Detection Distance: #{data[9]} , (#{PARAMETER_STRUCTURE[:min_detection_distance]})"
      output << "Maximum Detection Distance: #{data[10]} , (#{PARAMETER_STRUCTURE[:max_detection_distance]})"
      output << "Minimum Detection Angle: #{data[11]}° , (#{PARAMETER_STRUCTURE[:min_detection_angle]})"
      output << "Maximum Detection Angle: #{data[12]}° , (#{PARAMETER_STRUCTURE[:max_detection_distance]})"
      output << "Maximum Detection Speed: #{data[13]} , (#{PARAMETER_STRUCTURE[:min_detection_speed]})"
      output << "Maximum Detection Speed: #{data[14]} , (#{PARAMETER_STRUCTURE[:max_detection_speed]})"
      output << "Detection Direction: #{data[15]}"
      output << "Range Threshold: #{data[16]}%, (#{PARAMETER_STRUCTURE[:range_threshold]})"
      output << "Angle Threshold: #{data[17]}°, (#{PARAMETER_STRUCTURE[:angle_threshold]})"
      output << "Speed Threshold: #{data[18]}%, (#{PARAMETER_STRUCTURE[:speed_threshold]})"
      
      output
    end

    def request_parameter_data
      command = ['GRPS', 0]
      write command.pack('a4L')
      check_response
    end
  end
end
