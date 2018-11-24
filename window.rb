require 'gosu'

require_relative 'utils'
require_relative 'player'
require_relative 'map'
require_relative 'ui'

class OfficeWarsWindow < Gosu::Window
  def initialize
    @width = 640
    @height = 480

    super(@width, @height)
    self.caption = 'Office Wars'

    @ui = Ui.new(self, 0, 100, @width, @height)
    @state = :menu

    @player = Player.new
    @map = Map.new

    @end_round_button = Ui.new(self, @width - 150, @height - 50, 150, 50)
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
        layout.button('Practice', text_offset: 30)
        layout.button('Exit', text_offset: 65)
      end
    when :practice
      @map.draw
      @player.draw
      @end_round_button.vertical do |layout|
        layout.button('End round', text_offset: 10)
      end
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
        @map.select_coordinates(mouse_x, mouse_y)
        hexagon_target = @map.selected_hexagon
        puts "Clicked on hexagon #{hexagon_target[:indices]}" if DEBUG && !hexagon_target.nil?

        player_position = @map.to_hexagon(@player.x + 65 / 2, @player.y + 50 / 2)
        if hexagon_target && player_position && @map.distance_to_selected(player_position[:indices]) == 1
          @player.move_to(hexagon_target[:position][0], hexagon_target[:position][1])
        end

        @end_round_button.clicked(mouse_x, mouse_y) do |_text|
          @player.next_round
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
