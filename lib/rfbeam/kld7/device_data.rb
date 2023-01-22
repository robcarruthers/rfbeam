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
  end
end
