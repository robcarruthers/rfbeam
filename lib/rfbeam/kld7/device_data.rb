module RfBeam
  module KLD7
    # All supported Serial port baude rates
    BAUDE_RATES = { 0 => 115_200, 1 => 460_800, 2 => 921_600, 3 => 2_000_000, 4 => 3_000_000 }.freeze

    # 'INIT' command response codes
    RESP_CODES = {
      0 => 'OK',
      1 => 'Unknown command',
      2 => 'Invalid parameter value',
      3 => 'Invalid RPST version',
      4 => 'Uart error (parity, framing, noise)',
      5 => 'Sensor busy',
      6 => 'Timeout error',
    }.freeze

    # The response delay was determined empirically and may need adjusting with baude rate
    RESP_DELAY = 0.1

    # 'GNFD' command types
    FRAME_DATA_TYPES = { disabled: 0x00, radc: 0x01, rfft: 0x02, pdat: 0x04, tdat: 0x08, ddat: 0x10, done: 0x20 }.freeze

    # The angle, direction, range and speed flags are only valid if the detection flag is 1.
    DETECTION_FLAGS = {
      detection: ['No Detection', 'Detection'],
      micro_detection: ['No Detection', 'Detection'],
      angle: %w[Left Right],
      direction: %w[Receding Approaching],
      range: %w[Far Near],
      speed: %w[Low High],
    }
    
    # GRPS - Parameter structture, used to map return values to readable strings
    PARAMETER_STRUCTURE = {
      base_frequency: ['Low', 'Middle', 'High'],
      max_speed: ['12.5km/h', '25km/h', '50km/h', '100km/h'],
      max_range: %w[5m 10m 30m 100m],
      threshold_offset: '10db - 60db',
      tracking_filter_type: ['standard', 'Fast Detection', 'Long Visibility'],
      vibration_suppression: '0-16, 0 = No Suppression, 16 = High Suppression',
      min_detection_distance: '0 - 100% of range setting',      
      max_detection_distance: '0 - 100% of range setting',
      min_detection_angle: '-90° - 90°',
      max_detection_angle: '-90° - 90°',
      min_detection_speed: '0 - 100% of speed setting',
      max_detection_speed: '0 - 100% of speed setting',
      detection_direction: %w[receding approaching both],
      range_threshold: '0 - 100% of range setting',
      angle_threshold: '-90° - 90°',
      speed_threshold: '0 - 100% of speed setting',
      digital_output_1: %w[Direction Angle Range Speed Micro],
      digital_output_2: %w[Direction Angle Range Speed Micro],
      digital_output_3: %w[Direction Angle Range Speed Micro],
      hold_time: '1 - 7200s',
      micro_detection_trigger: %w[Off Retrigger],
      micro_detection_sensitivty: '0 - 9, 0 = Min, 9 = Max'
    }
  end
end
