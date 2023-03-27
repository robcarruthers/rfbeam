module RfBeam
  module KLD7
    def detection?
      data = ddat
      p data
      (data[2] == 1)
    end

    def tdat
      request_frame_data(:tdat)

      sleep 0.1
      resp = read(16).unpack('a4LSssS')
      return { dist: resp[2], speed: resp[3], angle: resp[4], mag: resp[5] } unless resp[1].zero?
    end

    def ddat
      request_frame_data(:ddat)

      resp = read(14).unpack('a4LC6')
      return resp
    end

    private

    def request_frame_data(type)
      command = ['GNFD', 4, FRAME_DATA_TYPES[type]]
      write command.pack('a4LL')
      check_response
    end
  end
end
