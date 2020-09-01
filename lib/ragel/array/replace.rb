# frozen_string_literal: true

require 'ripper'

module Ragel
  module Array
    class Replace < Ripper::SexpBuilderPP
      class Table
        attr_reader :source, :start_line, :end_line

        def initialize(left, right, lineno)
          @source = source_from(left[3][1], right[1].map { |int| int[1].to_i })
          @start_line = left[1][1][2][0] - 1
          @end_line = lineno
        end

        private

        def source_from(name, numbers)
          "self.#{name} = ::Ragel::Array.new(\"#{numbers.join(' ')}\", #{numbers.length})"
        end
      end

      class Buffer
        attr_reader :lines

        def initialize(source)
          @lines = source.split("\n")
        end

        def replace(table)
          buffer = lines[table.start_line][/\A\s+/]
          source = ["#{buffer}#{table.source}"]
          @lines = lines[0...table.start_line] + source + lines[table.end_line..-1]
        end

        def to_source
          "#{lines.join("\n")}\n"
        end
      end

      attr_reader :tables

      def initialize(*)
        super
        @tables = []
      end

      def each_table(&block)
        parse

        if error?
          warn 'Invalid ruby'
          exit 1
        end

        tables.reverse_each(&block)
      end

      def self.replace(source)
        buffer = Buffer.new(source)
        new(source).each_table { |table| buffer.replace(table) }
        buffer.to_source
      end

      private

      def on_assign(left, right)
        super.tap do
          next if left[0] != :field || right[0] != :array

          tables << Table.new(left, right, lineno)
        end
      end
    end
  end
end
