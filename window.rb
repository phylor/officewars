require 'gosu'

require_relative 'ui'

DEBUG = false

def draw_box(x, y, width, height, color = Gosu::Color::BLACK, z_index = 0)
  Gosu.draw_line(x, y, color, x + width, y, color, z_index)
  Gosu.draw_line(x + width, y, color, x + width, y + height, color, z_index)
  Gosu.draw_line(x + width, y + height, color, x, y + height, color, z_index)
  Gosu.draw_line(x, y + height, color, x, y, color, z_index)
end

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
