require 'hexagon'

class Map
  attr_reader :selected_hexagon, :player, :enemy

  def initialize
    @width = 65
    @height = 89
    @vertical_offset = 50

    @stone = Gosu::Image.new('assets/tileStone.png')
    @highlight = Gosu::Image.new('assets/tileLava.png')

    create_map

    @layout = Hexagon::Layout.new([50, 50], [65, 50], :pointy)
  end

  def draw
    start = Hexagon::Hex.new(0, 0)
    current = start

    5.times do
      x, y = @layout.to_pixel(current)

      @stone.draw(x, y - 25, 1)

      current = current.neighbor(:east)
    end
    #@map.each.with_index do |row, row_index|
    #  row.each.with_index do |hexagon, column_index|
    #    if !selected_hexagon.nil? && selected_hexagon[:indices] == [column_index, row_index]
    #      @highlight.draw(hexagon[0], hexagon[1], 1)
    #    else
    #      @stone.draw(hexagon[0], hexagon[1], 1)
    #    end
    #  end
    #end
  end

  def select_coordinates(x, y)
    @selected_hexagon = to_hexagon(x, y)
  end

  def distance_to_selected(indices)
    return -1 unless selected_hexagon

    return (selected_hexagon[:indices][0] - indices[0]).abs + (selected_hexagon[:indices][1] - indices[1]).abs
  end

  def to_hexagon(x, y)
    @layout.to_hexagon([x, y])
    #@map.each.with_index do |row, row_index|
    #  row.each.with_index do |hexagon, column_index|
    #    if inside_hexagon?(x, y, hexagon[0], hexagon[1], 65 / 2, 50 / 2)
    #      return { position: hexagon, indices: [column_index, row_index] }
    #    end
    #  end
    #end

    #nil
  end

  def add_player
    @player = Player.new
    @player_position = [0, 0]
  end

  def add_enemy
    x, y = @map[0][5]
    @enemy = Player.new(spritesheet: 'assets/enemy.png', x: x, y: y)
    @enemy_position = [5, 0]
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
