# frozen_string_literal: true

require 'test_helper'
require 'ragel/array/replace'

module Ragel
  class ArrayTest < Minitest::Test
    def test_version
      refute_nil Array::VERSION
    end

    def test_array
      array = Ragel::Array.new('10 20 30', 3)

      assert_equal 10, array[0]
      assert_equal 20, array[1]
      assert_equal 30, array[2]
    end

    def test_replace
      expected = <<~RUBY
        module Parser
          self._trans_keys = ::Ragel::Array.new("1 2 3 4 5", 5)
        end
      RUBY

      assert_equal expected, Array::Replace.replace(<<~RUBY)
        module Parser
          self._trans_keys = [
            1, 2, 3, 4, 5
          ]
        end
      RUBY
    end

    class NonComputeTable < Array::Replace::Table
      private

      def source_from(*)
        '-- REPLACED --'
      end
    end

    def test_replace_fixture
      fixture = File.join('fixtures', 'address_lists_parser.rb')
      source = File.read(File.expand_path(fixture, __dir__))

      replaced =
        Array::Replace::Table.stub(:new, NonComputeTable.method(:new)) do
          Array::Replace.replace(source)
        end

      assert_equal 7, replaced.scan('-- REPLACED --').size
    end
  end
end
