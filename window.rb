require 'gosu'

require_relative 'utils'
require_relative 'player'
require_relative 'ui'

class OfficeWarsWindow < Gosu::Window
  def initialize
    @width = 640
    @height = 480

    super(@width, @height)
    self.caption = 'Office Wars'

    @ui = Ui.new(self, @width, @height)
    @state = :menu

    @stone = Gosu::Image.new('assets/tileStone.png')
    @stone_alternate = Gosu::Image.new('assets/tileRock.png')
    @sand = Gosu::Image.new('assets/tileDirt.png')
    @highlight = Gosu::Image.new('assets/tileLava.png')
    
    @player = Player.new
    create_map
  end

  def needs_cursor?; true; end

  def update
    @player.move
  end

  def draw
    draw_background

    case @state
    when :menu
      @ui.vertical do |layout|
        layout.button('Practice', text_offset: 5)
        layout.button('Exit', text_offset: 55)
      end
    when :practice
      draw_map
      @player.draw
    end
  end

  def button_down(id)
    case id
    when Gosu::MS_LEFT
      case @state
      when :menu
        @ui.clicked(mouse_x, mouse_y) do |text|
          case text
          when 'Practice'
            @state = :practice
          when 'Exit'
            exit
          end
        end
      when :practice
        hexagon_target = to_hexagon(mouse_x, mouse_y)
        @player.move_to(hexagon_target[0], hexagon_target[1]) unless hexagon_target.nil?
      end
    when char_to_button_id('q')
      exit
    end
  end

  private

  def draw_background
    draw_rect(0, 0, @width, @height, Gosu::Color.new(238, 231, 205))
  end

  def create_map
    width = 65
    height = 89
    vertical_offset = 50

    @map = []

    4.times do |row|
      @map <<
        (0..3).map do |time|
          [
            [50 + time * 2 * width, 50 + row * height],
            [50 + time * 2 * width + width, 50 + row * height]
          ]
        end.flatten(1)
      @map << (0..3).map do |time|
        [
          [50 + width / 2 + time * 2 * width, 50 + row * height + vertical_offset],
          [50 + width / 2 + time * 2 * width + width, 50 + row * height + vertical_offset]
        ]
      end.flatten(1)
    end
  end

  def draw_map
    width = 65
    height = 89
    vertical_offset = 50

    @map.each.with_index do |row, row_index|
      row.each.with_index do |hexagon, column_index|
        if @selected_hexagon == [column_index, row_index]
          @highlight.draw(hexagon[0], hexagon[1], 1)
        else
          @stone.draw(hexagon[0], hexagon[1], 1)
        end
      end
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

  def to_hexagon(x, y)
    @map.each.with_index do |row, row_index|
      row.each.with_index do |hexagon, column_index|
        if inside_hexagon?(x, y, hexagon[0], hexagon[1], 65 / 2, 50 / 2)
          puts "Clicked on hexagon #{[column_index, row_index]}" if DEBUG
          @selected_hexagon = [column_index, row_index]
          return [hexagon[0], hexagon[1]]
        end
      end
    end

    nil
  end
end

OfficeWarsWindow.new.show
