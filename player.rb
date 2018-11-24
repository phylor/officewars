require_relative 'utils'

class Player
  def initialize
    @sprites = Gosu::Image.load_tiles('assets/player_tilesheet.png', 80, 115)
    @moving = false
    @x = 50
    @y = 50
    @x_offset = -10
    @y_offset = -65
  end

  def move
    if @moving
      @x += 0.75 * abs_norm(@target_x - @x)
      @y += 0.75 * abs_norm(@target_y - @y)

      if (@target_x - @x).abs < 0.6 && (@target_y - @y).abs < 0.6
        @moving = false
      end
    end
  end

  def move_to(x, y)
    @moving = true
    @target_x = x
    @target_y = y
  end

  def draw
    sprite = if @moving
               moving_indices = [0, 2, 16, 17]
               @sprites[moving_indices[Gosu.milliseconds / 100 % 4]]
             else
               @sprites[0]
             end

    sprite.draw(@x + @x_offset, @y + @y_offset, 2)

    draw_box(@x + @x_offset, @y + @y_offset, 80, 115, Gosu::Color::RED, 2) if DEBUG
  end

  private

  def abs_norm(number)
    return 1 if number.positive?
    return -1 if number.negative?
    0
  end
end
