require_relative 'square/map'
require_relative 'square/square'

class Map
  attr_reader :selected_hexagon, :player, :enemy

  def initialize
    @width = 65
    @height = 65
    @vertical_offset = 50

    @stone = Gosu::Image.new('assets/tile_office.png')
    @highlight = Gosu::Image.new('assets/tileLava.png')

    @map = Square::Map.new(8, 8, [50, 50], [55, 55])
  end

  def draw
    @map.each do |tile|
      x, y = @map.layout.to_pixel(tile)

      if tile == @selected_tile
        @highlight.draw(x, y, 1)
      else
        @stone.draw(x, y, 1)
      end
    end
  end

  def select_coordinates(x, y)
    @selected_tile = @map.layout.to_tile([x, y])
  end

  def add_player
    @player = Player.new
    @player_position = Square::Square.new(0, 0)
  end

  def add_enemy
    @enemy_position = Square::Square.new(1, 0)
    x, y = @map.layout.to_pixel(@enemy_position)
    @enemy = Player.new(spritesheet: 'assets/enemy.png', x: x, y: y)
  end

  def clicked_on(x, y)
    selected = @map.layout.to_tile([x, y])
    puts "clicked on [#{x}, #{y}] -> #{selected.inspect}"

    return unless @map.include?(selected)

    @selected_tile = selected

    distance = @player_position.distance_to(selected)
    puts "distance #{distance}"
    return unless distance == 1

    target_x, target_y = @map.layout.to_pixel(selected)

    case title_state(selected.x_pos, selected.y_pos)
    when :enemy
      player.attack(enemy)
      unless enemy.alive?
        @enemy = nil
        @enemy_position = nil
      end
    when :empty
      player.move_to(target_x, target_y)
      @player_position = selected
    end
  end

  private

  def title_state(x_pos, y_pos)
    if @enemy_position&.at?(x_pos, y_pos)
      :enemy
    elsif @player_position&.at?(x_pos, y_pos)
      :player
    else
      :empty
    end
  end
end
