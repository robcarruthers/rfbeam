require 'csv'

module RfBeam
  module KLD7
    def detection?
      data = ddat
      (data[2] == 1)
    end

    def rfft
      request_frame_data(:rfft)

      resp = read(1024).unpack('a4LS256S256')
      resp.shift 2
      resp
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
    
    # Get the radar parameter structure
    def grps
      command = ['GRPS', 0]
      write command.pack('a4L')
      check_response
      read(50).unpack('a4LA19C8c2C4cCCCCSCC')
    end

    def config
      data = grps
      output = "\n"
      RADAR_PARAMETERS.keys.each do |key|
        output << formatted_parameter(key, data[RADAR_PARAMETERS[key].grps_index])
      end
      output
    end
    
    def formatted_parameter(param, value = nil)
      param = RADAR_PARAMETERS[param]
      if value.nil?
        data = grps
        value = data[param.grps_index]
      end
      param_str_value = param.values.empty? ? value.to_s : param.values[value]
      "#{param.name}: #{param_str_value}#{param.units}\n"
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
  end
end
