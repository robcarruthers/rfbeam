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
      RADAR_PARAMETERS.each do |param|
        param = param[1]
        value = param.values.empty? ? data[param.grps_index] : param.values[data[param.grps_index].to_i]
        output << "#{param.name}: #{value}#{param.units}\n"
      end
      output
    end
  end
end
