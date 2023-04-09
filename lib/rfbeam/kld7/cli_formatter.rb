# frozen_string_literal: true

require 'tty-table'

module RfBeam
  module Kld7
    class CliFormatter
      def tdat(data)
        { dist: data[2], speed: data[3], angle: data[4], mag: data[5] }
      end

      def pdat_table(data)
        table = TTY::Table.new header: ['index', 'dist (M)', 'speed (Km/h)', 'angle (°)', 'mag (db)']
        count = data[1] / 8
        data.shift(2)
        count.times do |index|
          values = data.shift(4).map { |value| value.to_f / 100.0 }
          table << [index, values].flatten
        end
        table
      end

      def ddat(data)
        if data[2] == 1
          labels = ['Detection', 'Micro Detection', 'Angle', 'Direction', 'Range', 'Speed']
          labels
            .map
            .with_index { |label, index| "#{label}: #{DETECTION_FLAGS[to_symbol(label)][data[index + 2]]}" }
            .join("\n")
        else
          'DDAT: No Detection'
        end
      end

      private

      def to_symbol(string)
        modified_string = string.gsub(' ', '_').downcase
        modified_string.to_sym
      end
    end
  end
end