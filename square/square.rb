# frozen_string_literal: true

module Square
  class Square
    attr_reader :x_pos, :y_pos

    def initialize(x_pos, y_pos)
      @x_pos = x_pos
      @y_pos = y_pos
    end

    def distance_to(tile)
      (tile.x_pos - x_pos).abs.floor + (tile.y_pos - y_pos).abs.floor
    end

    def at?(test_x, test_y)
      x_pos == test_x && y_pos == test_y
    end
  end
end
