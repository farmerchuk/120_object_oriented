class Board
  attr_reader :squares

  def initialize
    @squares = initialize_squares
  end

  def initialize_squares
    (1..9).each_with_object({}) { |sqr, board| board[sqr] = Square.new }
  end

  def square_at(position)
    squares[position]
  end

  def set_square_at(position, marker)
    squares[position].marker = marker
  end
end

class Square
  attr_accessor :marker

  def initialize(marker = ' ')
    @marker = marker
  end

  def to_s
    marker
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMP_MARKER = 'O'

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMP_MARKER)
  end

  def display_welcome_message
    puts 'Welcome to Tic-Tac-Toe!'
    puts
  end

  def display_goodbye_message
    puts 'Thanks for playing!'
  end

  def display_board
    puts "     |     |     "
    puts "  #{board.square_at(1)}  |  #{board.square_at(2)}  |  #{board.square_at(3)}  "
    puts "-----|-----|-----"
    puts "  #{board.square_at(4)}  |  #{board.square_at(5)}  |  #{board.square_at(6)}  "
    puts "-----|-----|-----"
    puts "  #{board.square_at(7)}  |  #{board.square_at(8)}  |  #{board.square_at(9)}  "
    puts "     |     |     "
    puts
  end

  def human_moves
    input = nil
    loop do
      print 'Choose a square between 1 and 9: '
      input = gets.chomp.to_i
      break if (1..9).include? input
      puts 'Sorry, that is not a valid choice...'
    end
    board.set_square_at(input, human.marker)
  end

  def computer_moves
    input = (1..9).to_a.sample
    board.set_square_at(input, computer.marker)
  end

  def play
    display_welcome_message
    loop do
      display_board
      human_moves
      # display_board
      # break if someone_won? || board_full?

      computer_moves
      # break if someone_won? || board_full?
      display_board
      break
    end
    # display_result
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
