DEBUG = false

class Utils
  def self.draw_box(x, y, width, height, color = Gosu::Color::BLACK, z_index = 0)
    Gosu.draw_line(x, y, color, x + width, y, color, z_index)
    Gosu.draw_line(x + width, y, color, x + width, y + height, color, z_index)
    Gosu.draw_line(x + width, y + height, color, x, y + height, color, z_index)
    Gosu.draw_line(x, y + height, color, x, y, color, z_index)
  end
end
