# frozen_string_literal: true

require_relative 'square'

module Square
  class Layout
    def initialize(tiles_in_width, tiles_in_height, tile_size, window_offset)
      @tiles_in_width = tiles_in_width
      @tiles_in_height = tiles_in_height
      @tile_size = tile_size
      @window_offset = window_offset
    end

    def each(&block)
      squares.each(&block)
    end

    def to_pixel(tile)
      [
        @window_offset[0] + tile.x_pos * @tile_size[0],
        @window_offset[1] + tile.y_pos * @tile_size[1]
      ]
    end

    def to_tile(coordinates)
      x = coordinates[0]
      y = coordinates[1]

      x_pos = (x - @window_offset[0]) / @tile_size[0]
      y_pos = (y - @window_offset[1]) / @tile_size[1]

      Square.new(x_pos.floor, y_pos.floor)
    end

    def include?(tile)
      tile.x_pos >= 0 &&
        tile.y_pos >= 0 &&
        tile.x_pos <= @tile_size[0] &&
        tile.y_pos <= @tile_size[1]
    end

    private

    def squares
      positions.map do |x_pos, y_pos|
        Square.new(x_pos, y_pos)
      end
    end

    def positions
      (0..@tiles_in_height).flat_map do |y|
        (0..@tiles_in_width).to_a.map do |x|
          [x, y]
        end
      end
    end
  end
end
