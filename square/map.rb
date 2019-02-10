# frozen_string_literal: true

require_relative 'layout'

module Square
  class Map
    attr_reader :layout

    def initialize(tiles_in_width, tiles_in_height, tile_size, window_offset)
      @layout = Layout.new(tiles_in_width, tiles_in_height, tile_size, window_offset)
    end

    def each(&block)
      @layout.each(&block)
    end

    def include?(tile)
      @layout.include?(tile)
    end
  end
end
