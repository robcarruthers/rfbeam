module RfBeam
  module KLD7
    def detection?
      data = ddat
      (data[2] == 1)
    end
    
    def pdat(formatted: false)
      request_frame_data(:pdat)      
      resp = read(102).unpack('a4LSssSSssSSssSSssSSssSSssSSssSSssSSssSSssS')
      return resp unless formatted

      target_count = resp[1].to_i / 8
      return [] unless target_count > 0

      resp.shift 2
      resp.compact
      detected_raw_targets = []
      target_count.times { detected_raw_targets << format_raw_target_data(resp.shift(4)) }
      detected_raw_targets
    end

    def tdat
      request_frame_data(:tdat)

      sleep 0.1
      resp = read(16).unpack('a4LSssS')
      return { dist: resp[2], speed: resp[3], angle: resp[4], mag: resp[5] } unless resp[1].zero?
    end

    def ddat
      request_frame_data(:ddat)

      read(14).unpack('a4LC6')
    end
    
    def config
      puts formatted_grps(grps)
    end
    
    def formatted_parameter(param)
      return unless PARAMETERS.include? param
      
      param_data = PARAMETERS[param]
      grps_data = grps
      index = grps_data[param_data[:grps_index]]
      param_data[:values][index]
    end

    # Get the radar parameter structure
    def grps
      command = ['GRPS', 0]
      write command.pack('a4L')
      check_response
      read(50).unpack('a4LA19C8c2C4cCCCCSCC')
    end
    

    private

    def format_raw_target_data(array)
        { dist: array.shift, speed: array.shift, angle: array.shift, mag: array.shift }
    end

    def request_frame_data(type)
      command = ['GNFD', 4, FRAME_DATA_TYPES[type]]
      write command.pack('a4LL')
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
