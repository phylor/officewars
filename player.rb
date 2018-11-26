require_relative 'utils'

class Player
  attr_reader :x, :y, :position

  def initialize(spritesheet: 'assets/player_tilesheet.png', position: Hexagon::Hex.new(0, 0), layout:)
    @sprites = Gosu::Image.load_tiles(spritesheet, 80, 115)
    @moving = false
    @position = position
    @layout = layout
    @x, @y = @layout.to_pixel(@position)
    @x_offset = -10 - 25
    @y_offset = -115 + 20
    @max_energy = 3
    @energy = 3
    @hit_points = 1
    @attack_points = 1
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

  def can_reach?(target_position)
    @energy >= @position.distance_to(target_position)
  end

  def move_to(target_position)
    return unless can_reach?(target_position)

    @moving = true
    @target_x, @target_y = @layout.to_pixel(target_position)
    @energy -= @position.distance_to(target_position)
    @position = target_position
  end

  def draw
    sprite = if @moving
               moving_indices = [0, 2, 16, 17]
               @sprites[moving_indices[Gosu.milliseconds / 100 % 4]]
             elsif dead?
               @sprites[4]
             else
               @sprites[0]
             end

    sprite.draw(@x + @x_offset, @y + @y_offset, 2)

    draw_energy_bar

    Utils.draw_box(@x + @x_offset, @y + @y_offset, 80, 115, Gosu::Color::RED, 2) if DEBUG
  end

  def next_round
    @energy = @max_energy
  end

  def attack(enemy)
    enemy.hit(@attack_points)
    @energy -= 1
  end

  def hit(damage)
    @hit_points -= damage
  end

  def dead?
    @hit_points <= 0
  end

  private

  def draw_energy_bar
    Gosu.draw_rect(@x + @x_offset + 10, @y + @y_offset + 20, 10, 30, Gosu::Color.new(238, 238, 238), 2)
    Gosu.draw_rect(@x + @x_offset + 10, @y + @y_offset + 20 + (30 - 30 * @energy / @max_energy), 10, 30 * @energy / @max_energy, Gosu::Color.new(255, 204, 0), 2)
    Utils.draw_box(@x + @x_offset + 10, @y + @y_offset + 20, 10, 30, Gosu::Color.new(152, 152, 152), 2)
  end

  def abs_norm(number)
    return 1 if number.positive?
    return -1 if number.negative?
    0
  end
end
