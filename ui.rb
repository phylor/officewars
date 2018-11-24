class Ui
  def initialize(window, x, y, width, height)
    @window = window
    @x = x
    @y = y
    @width = width
    @height = height
    @sprites = Gosu::Image.new('assets/ui-yellow.png')
  end

  def vertical
    @layout = Ui::VerticalLayout.new(@window, @sprites, @x, @y, @width, @height)
    yield @layout
  end

  def clicked(x, y, &block)
    @layout.clicked(x, y, &block)
  end
end

class Ui::VerticalLayout
  BUTTON_WIDTH = 190
  BUTTON_HEIGHT = 49

  def initialize(window, sprites, ui_x, ui_y, width, height)
    @sprites = sprites
    @font = Gosu::Font.new(window, 'assets/Kenney Future Narrow.ttf', 30)
    @x = ui_x + (width - BUTTON_WIDTH) / 2
    @y = ui_y
    @buttons = []
  end

  def button(text, text_offset: 0)
    @buttons << [@x, @y, text]

    @sprites.subimage(190, 45, BUTTON_WIDTH, BUTTON_HEIGHT).draw(@x, @y, 1)
    @font.draw_text(text, @x + text_offset, @y + 8, 2, 1, 1, Gosu::Color.new(149, 119, 2))

    @y += BUTTON_HEIGHT + 15
  end

  def clicked(mouse_x, mouse_y)
    @buttons.each do |x, y, text|
      if mouse_x >= x && mouse_x <= x + BUTTON_WIDTH && mouse_y >= y && mouse_y <= y + BUTTON_HEIGHT
        yield text
      end
    end
  end
end
