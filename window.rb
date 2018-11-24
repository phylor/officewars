require 'gosu'

class OfficeWarsWindow < Gosu::Window
  def initialize
    @width = 640
    @height = 480

    super(@width, @height)

    self.caption = 'Office Wars'
  end

  def update

  end

  def draw
    draw_background
  end

  private

  def draw_background
    draw_rect(0, 0, @width, @height, Gosu::Color.new(238, 231, 205))
  end
end

OfficeWarsWindow.new.show
