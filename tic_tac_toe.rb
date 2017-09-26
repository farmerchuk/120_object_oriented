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

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |     "
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}  "
    puts "-----|-----|-----"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}  "
    puts "-----|-----|-----"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}  "
    puts "     |     |     "
  end
  # rubocop:enable Metrics/AbcSize

  def []=(position, marker)
    squares[position].marker = marker
  end

  def empty_square_positions
    squares.keys.select { |key| squares[key].unmarked? }
  end

  def full?
    empty_square_positions.empty?
  end

  def winner?
    !!winning_marker
  end

  def winning_marker
    TTTGame::PLAYERS.each_value do |marker|
      WINNING_LINES.each do |line|
        return marker if line.all? { |pos| squares[pos].marker == marker }
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
  PLAYERS = { human: 'X', computer: 'O' }

  def initialize
    @board = Board.new
    @human = Player.new(PLAYERS[:human])
    @computer = Player.new(PLAYERS[:computer])
    @turn_order = PLAYERS.keys
  end

  def play
    display_welcome_message

    loop do
      display_board

      loop do
        current_player_moves
        display_board
        break if board.winner? || board.full?
      end
      display_result
      break unless play_again?
      reset_board
    end

    display_goodbye_message
  end

  private

  attr_reader :board, :human, :computer, :turn_order

  def clear
    system 'clear'
  end

  def display_welcome_message
    puts 'Welcome to Tic-Tac-Toe!'
    puts
  end

  def display_goodbye_message
    puts 'Thanks for playing!'
  end

  def display_board
    clear
    puts "You're a #{human.marker}"
    puts "Computer is a #{computer.marker}"
    puts
    board.draw
    puts
  end

  def current_player_moves
    turn_order.first == :human ? human_moves : computer_moves
    set_next_player_turn
  end

  def set_next_player_turn
    turn_order.reverse!
  end

  def human_moves
    input = nil
    loop do
      print "Choose a square from #{board.empty_square_positions.join(', ')}: "
      input = gets.chomp.to_i
      break if board.empty_square_positions.include?(input)
      puts 'Sorry, that is not a valid choice...'
    end
    board[input] = human.marker
  end

  def computer_moves
    input = board.empty_square_positions.to_a.sample
    board[input] = computer.marker
  end

  def display_result
    display_board

    if board.full? && !board.winner?
      puts "It's a tie!"
    else
      puts "The winner is #{board.winning_marker}!"
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
end

game = TTTGame.new
game.play
