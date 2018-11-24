require 'gosu'

require_relative 'ui'

class OfficeWarsWindow < Gosu::Window
  def initialize
    @width = 640
    @height = 480

    super(@width, @height)
    self.caption = 'Office Wars'


    @ui = Ui.new(self, @width, @height)
  end

  def needs_cursor?; true; end

  def update

  end

  def draw
    draw_background

    @ui.vertical do |layout|
      layout.button('Practice', text_offset: 5)
      layout.button('Exit', text_offset: 55)
    end
  end

  def button_down(id)
    case id
    when Gosu::MS_LEFT
      @ui.clicked(mouse_x, mouse_y) do |text|
        case text
        when 'Practice'
          puts 'starting game'
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
end

OfficeWarsWindow.new.show
