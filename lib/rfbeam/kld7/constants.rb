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
      6 => 'Timeout error'
    }.freeze

    # Delays are determined empirically and may need adjusting with baude rate
    RESPONSE_DELAY = 0.05
    MEASUREMENT_DELAY = 0.15

    # 'GNFD' command types
    FRAME_DATA_TYPES = { disabled: 0x00, radc: 0x01, rfft: 0x02, pdat: 0x04, tdat: 0x08, ddat: 0x10, done: 0x20 }.freeze

    # The angle, direction, range and speed flags are only valid if the detection flag is 1.
    DETECTION_FLAGS = {
      detection: %w[No Yes],
      micro_detection: %w[No Yes],
      angle: %w[Left Right],
      direction: %w[Receding Approaching],
      range: %w[Far Near],
      speed: %w[Low High]
    }.freeze

    Param =
      Struct.new(:name, :grps_index, :description, :default, :units, :values) do
        def initialize(name:, grps_index:, description: nil, default: nil, units: nil, values: [])
          super(name, grps_index, description, default, units, values)
        end
      end

    RADAR_PARAMETERS = {
      sw_version: Param.new(name: 'Software Version', grps_index: 2, default: 'K-LD7_APP-RFB-XXXX'),
      base_frequency:
        Param.new(
          name: 'Base Frequency',
          grps_index: 3,
          description: '0 = Low, 1 = Middle, 2 = High',
          default: 1,
          values: %w[Low Middle High]
        ),
      max_speed:
        Param.new(
          name: 'Maximum Speed',
          grps_index: 4,
          description: '0 = 12km/h, 1 = 25km/h, 2 = 50km/h, 3 = 100km/h',
          default: 1,
          units: 'km/h',
          values: %w[12.5 25 50 100]
        ),
      max_range:
        Param.new(
          name: 'Maximum Range',
          grps_index: 5,
          description: '0 = 5m, 1 = 10m, 2 = 30m, 3 = 100m',
          default: 1,
          values: %w[5m 10m 30m 100m]
        ),
      threshold_offset:
        Param.new(name: 'Threshold Offset', grps_index: 6, description: '10db - 60db', default: 30, units: 'db'),
      tracking_filter:
        Param.new(
          name: 'Tracking Filter Type',
          grps_index: 7,
          description: '0 = Standard, 2 = Fast Detection, 3 = Long Visibility',
          default: 0,
          values: ['standard', 'Fast Detection', 'Long Visibility']
        ),
      vibration_suppression:
        Param.new(
          name: 'Vibration Suppression',
          grps_index: 8,
          description: '0-16, 0 = No Suppression, 16 = High Suppression',
          default: 2
        ),
      min_detection_distance:
        Param.new(
          name: 'Minimum Detection Distance',
          grps_index: 9,
          description: '0 - 100% of range setting',
          default: 0,
          units: '%'
        ),
      max_detection_distance:
        Param.new(
          name: 'Maximum Detection Distance',
          grps_index: 10,
          description: '0 - 100% of range setting',
          default: 50,
          units: '%'
        ),
      min_detection_angle:
        Param.new(name: 'Minimum Detection Angle', grps_index: 11, description: '-90° - 90°', default: -90, units: '°'),
      max_detection_angle:
        Param.new(name: 'Maximum Detection Angle', grps_index: 12, description: '-90° - 90°', default: 90, units: '°'),
      min_detection_speed:
        Param.new(
          name: 'Minimum Detection Speed',
          grps_index: 13,
          description: '0 - 100% of speed setting',
          default: 0,
          units: '%'
        ),
      max_detection_speed:
        Param.new(
          name: 'Maximum Detection Speed',
          grps_index: 14,
          description: '0 - 100% of speed setting',
          default: 100,
          units: '%'
        ),
      detection_direction:
        Param.new(
          name: 'Detection Direction',
          grps_index: 15,
          description: '0 = Receding, 1 = Approaching, 2 = Both',
          default: 2,
          values: %w[Receding Approaching Both]
        ),
      range_threshold:
        Param.new(
          name: 'Range Threshold',
          grps_index: 16,
          description: '0 - 100% of range setting',
          default: 10,
          units: '%'
        ),
      angle_threshold:
        Param.new(name: 'Angle Threshold', grps_index: 17, description: '-90° - 90°', default: 0, units: '°'),
      speed_threshold:
        Param.new(
          name: 'Speed Threshold',
          grps_index: 18,
          description: '0 - 100% of speed setting',
          default: 50,
          units: '%'
        ),
      digital_output1:
        Param.new(
          name: 'Digital Output 1',
          grps_index: 19,
          description: '0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection',
          default: 0,
          values: %w[Direction Angle Range Speed Micro]
        ),
      digital_output2:
        Param.new(
          name: 'Digital Output 2',
          grps_index: 20,
          description: '0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection',
          default: 1,
          values: %w[Direction Angle Range Speed Micro]
        ),
      digital_output3:
        Param.new(
          name: 'Digital Output 3',
          grps_index: 21,
          description: '0 = Direction, 1 = Angle, 2 = Range, 3 = Speed, 4 = Micro Detection',
          default: 2,
          values: %w[Direction Angle Range Speed Micro]
        ),
      hold_time: Param.new(name: 'Hold Time', grps_index: 22, description: '1 - 7200s', default: 1, units: 's'),
      micro_detection_retrigger:
        Param.new(
          name: 'Micro Detection Trigger',
          grps_index: 23,
          description: '0 = Off, 1 = Retrigger',
          default: 0,
          values: %w[Off Retrigger]
        ),
      micro_detection_sensativity:
        Param.new(
          name: 'Micro Detection Sensativity',
          grps_index: 24,
          description: '0 - 9, 0 = Min, 9 = Max',
          default: 4
        )
    }.freeze
  end
end
