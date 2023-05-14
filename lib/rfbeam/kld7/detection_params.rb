# frozen_string_literal: true

module RfBeam
  module KLD7
    # -----------------
    # Minimum Detection distance, 0 - 100% of Range setting, default = 0
    # -----------------
    def min_detection_distance
      query_parameter RADAR_PARAMETERS[:min_detection_distance].grps_index
    end

    def min_detection_distance=(value = 0)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..100).cover?(value)
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
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..100).cover?(value)
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
      raise ArgumentError, "Invalid arg: '#{angle}'" unless (-90..90).cover?(angle)
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
      raise ArgumentError, "Invalid arg: '#{angle}'" unless (-90..90).cover?(angle)
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
      raise ArgumentError, "Invalid arg: '#{speed}'" unless (0..100).cover?(speed)
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
      raise ArgumentError, "Invalid arg: '#{speed}'" unless (0..100).cover?(speed)
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
      raise ArgumentError, "Invalid arg: '#{direction}'" unless (0..2).cover?(direction)
      raise ArgumentError, 'Expected an Integer' unless direction.is_a?(Integer)

      set_parameter :dedi, direction, :uint32
    end
    alias dedi= detection_direction=
    alias set_detection_direction detection_direction=

    # -----------------
    # Micro Detection retrigger, 0 = Off (default), 1 = Retrigger
    # -----------------
    def micro_detection_retrigger
      query_parameter RADAR_PARAMETERS[:set_micro_detection_retrigger].grps_index
    end

    def micro_detection_retrigger=(value = 0)
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..1).cover?(value)
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
      raise ArgumentError, "Invalid arg: '#{value}'" unless (0..9).cover?(value)
      raise ArgumentError, 'Expected an Integer' unless value.is_a?(Integer)

      set_parameter :mids, value, :uint32
    end
    alias mids= micro_detection_sensitivity=
    alias set_micro_detection_sensitivity micro_detection_sensitivity=
  end
end
