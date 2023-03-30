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
    
    # GRPS - Parameter structure, used to map return values to readable strings
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
      micro_detection_sensitivity: '0 - 9, 0 = Min, 9 = Max'
    }
    
    PARAMETERS = {
      sw_version: { grps_index: 2, default: 'K-LD7_APP-RFB-XXXX' },
      base_frequency: { grps_index: 3, description: '0 = Low, 1 = Middle, 2 = High', default: '1 - Middle', values: ['Low', 'Middle', 'High'] },
      max_speed: { grps_index: 4, description: '0 = 12km/h, 1 = 25km/h, 2 = 50km/h, 3 = 100km/h, default: 1', values: ['12.5km/h', '25km/h', '50km/h', '100km/h'] },
      max_range: { grps_index: 5, description: '0 = 5m, 1 = 10m, 2 = 30m, 3 = 100m, default: 1', values: %w[5m 10m 30m 100m] },
      threshold_offset: { grps_index: 6, description: '10db - 60db, default: 30', values: '10db - 60db' },
      tracking_filter_type: { grps_index: 7, description: '0 = Standard, 2 = Fast Detection, 3 = Long Visibility, default: 0', values: ['standard', 'Fast Detection', 'Long Visibility'] },
      vibration_suppression: { grps_index: 8, description: '0-16, 0 = No Suppression, 16 = High Suppression, default: 2' },
      min_detection_distance: { grps_index: 3, description: '0 - 100% of range setting, default: 0' },
      max_detection_distance: { grps_index: 10, description: '0 - 100% of range setting, default: 50' },
      min_detection_angle: { grps_index: 11, description: '-90° - 90°, default: -90' },
      max_detection_angle: { grps_index: 12, description: '-90° - 90°, default: 90' },
      min_detection_speed: { grps_index: 13, description: '0 - 100% of speed setting, default: 0' },
      max_detection_speed: { grps_index: 14, description: '0 - 100% of speed setting, default: 100' },
      detection_direction: { grps_index: 15, description: '0 = Receding, 1 = Approaching, 2 = Both, default: 2', values: %w[receding approaching both] },
      range_threshold: { grps_index: 16, description: '0 - 100% of range setting, default: 10', values: '0 - 100% of range setting' },
      angle_threshold: { grps_index: 17, description: '-90° - 90°, default: 0' },
      speed_threshold: { grps_index: 18, description: '0 - 100% of speed setting, default: 50' },
      digital_output_1: { grps_index: 19, description: '0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default: 0', values: %w[Direction Angle Range Speed Micro] },
      digital_output_2: { grps_index: 20, description: '0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default: 1', values: %w[Direction Angle Range Speed Micro] },
      digital_output_3: { grps_index: 21, description: '0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection, default: 2', values: %w[Direction Angle Range Speed Micro] },
      hold_time: { grps_index: 22, description: '1 - 7200s, default: 1', values: '1 - 7200s' },
      micro_detection_trigger: { grps_index: 23, description: '0 = Off, 1 = Retrigger, default: 0' },
      micro_detection_sensitivity: { grps_index: 24, description: '0 - 9, 0 = Min, 9 = Max, default: 4' }'
    }
  end
end
