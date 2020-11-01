require 'gosu'
require 'hasu'

Hasu.load("square.rb")
Hasu.load("board.rb")

class Game < Hasu::Window
  Z_FRONT ||= 100

  def initialize
    super 600, 600
    self.caption = "改造⭕️❌ゲーム"
    
  end

  def reset
    @state = :new_game
    @board = Board.new(width, height)
    @cursor = Gosu::Image.new('cursor.png',tileable=false)
    @current_letter = "O"
    
  end

  def update
  end

  def button_down(id)
    case id
    #　escキーが押された処理
    when Gosu::KbEscape
      close
    when Gosu::MsLeft
      process_click
    end
  end

  def start_game
    @winner = nil
    @board.clear
    @state = :playing
  end

  def process_click
    case @state
    when :new_game, :cats_game, :winner
      start_game
    when :playing
      if @board.mark_letter @current_letter, mouse_x, mouse_y
        check_win? || full_board?
        swap_letter
      end
    end
  end

  def check_win?
    if @board.check_win?
      @state = :winner
      @winner = @current_letter
    end
  end

  def full_board?
    if @board.full?
      @state = :cats_game
    end
  end

  def swap_letter
    @current_letter = case @current_letter
      when "O" then "X"
      else "O"
    end
  end

  def draw
    Gosu.draw_rect 0, 0, width, height, Gosu::Color::WHITE
    @board.draw
    draw_overlay unless @state == :playing

    @cursor.draw mouse_x, mouse_y, Z_FRONT, 0.5, 0.5

    case @state
    when :new_game
      font = Gosu::Font.new(50)
      font.draw_text_rel("クリックすると始まるよ！！", width/2, height/2, 0, 0.5, 0.5, 1, 1,  Gosu::Color::RED)
    when :winner
      font = Gosu::Font.new(50)
      font.draw_text_rel("#{@winner}の勝ちだぜっ！！", width / 2, height / 2, 0, 0.5, 0.5, 1, 1, Gosu::Color::GREEN)
    #引き分け
    when :cats_game
      font = Gosu::Font.new(50)
      font.draw_text_rel("引き分けだぜ〜", width / 2, height / 2, 2, 0.5, 0.5, 1, 1, Gosu::Color::BLUE)
      background = Gosu::Image.new("haikei.jpg", false)
      background.draw(0, 0, 1)
    when :playing
    end
  end

  def draw_overlay
    Gosu.draw_rect 0, 0, width, height, Gosu::Color.argb(0xdd_666666)
  end

end

Game.run
