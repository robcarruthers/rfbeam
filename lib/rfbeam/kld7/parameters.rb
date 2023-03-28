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

    def request_parameter_data
      command = ['GRPS', 0]
      write command.pack('a4L')
      check_response
    end
  end
end
