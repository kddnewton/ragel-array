# frozen_string_literal: true

require 'ragel/array/version'
require 'ragel/array/ragel_array'

module Ragel
  class Array
    def self.replace(filepath)
      require 'ragel/array/replace'

      File.write(filepath, Replace.replace(File.read(filepath)))
    end
  end
end
