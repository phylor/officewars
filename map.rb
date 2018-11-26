require 'hexagon'

class Map
  attr_reader :selected_hexagon, :player, :enemy

  def initialize
    @width = 65
    @height = 89
    @vertical_offset = 50

    @stone = Gosu::Image.new('assets/tileStone.png')
    @highlight = Gosu::Image.new('assets/tileLava.png')

    @hex_map = Hexagon::Map.new(:rectangle_a, :pointy, 8, 8, [50, 50], [55, 55])
  end

  def draw
    @hex_map.each do |hexagon|
      x, y = @hex_map.layout.to_pixel(hexagon)

      if hexagon == @selected_hexagon
        @highlight.draw(x, y, 1)
      else
        @stone.draw(x, y, 1)
      end
    end
  end

  def select_coordinates(x, y)
    @selected_hexagon = @hex_map.layout.to_hexagon([x, y])
  end

  def add_player
    @player = Player.new
    @player_position = Hexagon::Hex.new(0, 0)
  end

  def add_enemy
    @enemy_position = Hexagon::Hex.new(1, 0)
    x, y = @hex_map.layout.to_pixel(@enemy_position)
    @enemy = Player.new(spritesheet: 'assets/enemy.png', x: x, y: y)
  end

  def clicked_on(x, y)
    selected = @hex_map.layout.to_hexagon([x, y])
    puts "clicked on [#{x}, #{y}] -> #{selected.inspect}"

    #return unless @hex_map.include?(selected)

    #puts "included in map"

    @selected_hexagon = selected

    distance = @player_position.distance_to(selected)
    puts "distance #{distance}"
    return unless distance == 1

    target_x, target_y = @hex_map.layout.to_pixel(selected)
    if player.move_to(target_x, target_y)
      @player_position = selected
    end
  end

  private

  def create_map
    @map = []

    4.times do |row|
      @map <<
        (0..3).map do |time|
          [
            [50 + time * 2 * @width, 50 + row * @height],
            [50 + time * 2 * @width + @width, 50 + row * @height]
          ]
        end.flatten(1)
      @map << (0..3).map do |time|
        [
          [50 + @width / 2 + time * 2 * @width, 50 + row * @height + @vertical_offset],
          [50 + @width / 2 + time * 2 * @width + @width, 50 + row * @height + @vertical_offset]
        ]
      end.flatten(1)
    end
  end

  def inside_hexagon?(x, y, hexagon_x, hexagon_y, hexagon_width, hexagon_height)
    # http://www.playchilla.com/how-to-check-if-a-point-is-inside-a-hexagon
    hexagon_center_x = hexagon_x + hexagon_width
    hexagon_center_y = hexagon_y + hexagon_height
    q2x = (x - hexagon_center_x).abs
    q2y = (y - hexagon_center_y).abs

    return false if q2x > hexagon_width / 2 || q2y > hexagon_height * 2

    2 * hexagon_height * hexagon_width - hexagon_height * q2x - hexagon_width * q2y >= 0
  end
end
