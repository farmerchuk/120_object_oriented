class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonal

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

  def empty_square_positions
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    empty_square_positions.empty?
  end

  def winner?
    !!detect_winner
  end

  def detect_winner
    WINNING_LINES.each do |line|
      if line.all? { |pos| square_at(pos).marker == TTTGame::HUMAN_MARKER }
        return TTTGame::HUMAN_MARKER
      elsif line.all? { |pos| square_at(pos).marker == TTTGame::COMP_MARKER }
        return TTTGame::COMP_MARKER
      end
    end
    nil
  end

  def reset
    initialize
  end
end

class Square
  EMPTY_SQUARE = ' '

  attr_accessor :marker

  def initialize(marker = EMPTY_SQUARE)
    @marker = marker
  end

  def unmarked?
    marker == EMPTY_SQUARE
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
    system 'clear'
    puts "You're a #{human.marker}"
    puts "Computer is a #{computer.marker}"
    puts
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
      print "Choose a square from #{board.empty_square_positions.join(', ')}: "
      input = gets.chomp.to_i
      break if board.empty_square_positions.include?(input)
      puts 'Sorry, that is not a valid choice...'
    end
    board.set_square_at(input, human.marker)
  end

  def computer_moves
    input = board.empty_square_positions.to_a.sample
    board.set_square_at(input, computer.marker)
  end

  def display_result
    display_board

    if board.full? && !board.winner?
      puts "It's a tie!"
    else
      puts "The winner is #{board.detect_winner}!"
    end
  end

  def play_again?
    input = nil
    loop do
      print 'Would you like to play again? (y/n): '
      input = gets.chomp.downcase
      break if ['y', 'n'].include?(input)
      puts 'Sorry, that is not a valid choice...'
    end
    input == 'y'
  end

  def reset_board
    board.reset
  end

  def play
    display_welcome_message

    loop do
    display_board

      loop do
        human_moves
        break if board.winner? || board.full?
        display_board

        computer_moves
        break if board.winner? || board.full?

        display_board
      end
      display_result
      break unless play_again?
      reset_board
    end

    display_goodbye_message
  end
end

game = TTTGame.new
game.play
