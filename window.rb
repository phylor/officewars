require 'gosu'

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
  end

  def needs_cursor?; true; end

  def update

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
    end
  end

  def button_down(id)
    case id
    when Gosu::MS_LEFT
      @ui.clicked(mouse_x, mouse_y) do |text|
        case text
        when 'Practice'
          @state = :practice
        when 'Exit'
          exit
        end
      end
    when char_to_button_id('q')
      exit
    end
  end

  private

  def draw_background
    draw_rect(0, 0, @width, @height, Gosu::Color.new(238, 231, 205))
  end

  def draw_map
    width = 65
    height = 89
    vertical_offset = 50

    4.times do |row|
      4.times do |time|
        @stone.draw(50 + time * 2 * width, 50 + row * height, 1)
        @stone_alternate.draw(50 + time * 2 * width + width, 50 + row * height, 1)
      end
      4.times do |time|
        @stone.draw(50 + width / 2 + time * 2 * width, 50 + row * height + vertical_offset, 1)
        @sand.draw(50 + width / 2 + time * 2 * width + width, 50 + row * height + vertical_offset, 1)
      end
    end
  end
end

OfficeWarsWindow.new.show
