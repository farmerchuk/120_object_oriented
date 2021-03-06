class Board
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
  attr_accessor :score, :marker
  attr_reader :name

  def initialize(name, marker = nil)
    @marker = marker
    @score = 0
    @name = name
  end

  def increment_score
    self.score += 1
  end

  def score_reset
    self.score = 0
  end

  def choose_marker
    input = nil
    loop do
      print "Would you like to play as 'X' or 'O'? "
      input = gets.chomp.upcase
      break if ['X', 'O'].include?(input)
      puts 'Sorry, that is not a valid option...'
    end
    self.marker = input
  end

  def to_s
    name
  end
end

class TTTGame
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonal
  WINNING_SCORE = 5

  def initialize
    @board = Board.new
    @human = Player.new('Jason')
    @computer = Player.new('R2D2')
    @player_turn_order = [@human, @computer]
  end

  def play
    display_welcome_message
    set_player_markers
    loop do
      game_round_loop
      display_game_winner
      break unless play_again?
      reset_game
    end
    display_goodbye_message
  end

  private

  attr_reader :board, :human, :computer, :player_turn_order

  def player_turn_loop
    loop do
      current_player_moves
      display_board
      break if round_winner? || board.full?
    end
  end

  def game_round_loop
    loop do
      display_board
      player_turn_loop
      adjust_scores
      display_result
      break if game_winner?
      continue
      reset_round
    end
  end

  def clear
    system 'clear'
  end

  def display_welcome_message
    clear
    puts 'Welcome to Tic-Tac-Toe!'
    puts
  end

  def display_goodbye_message
    puts 'Thanks for playing!'
  end

  def set_player_markers
    human.choose_marker
    human.marker == 'X' ? computer.marker = 'O' : computer.marker = 'X'
  end

  def display_board
    clear
    display_player_info
    puts
    board.draw
    puts
  end

  def display_player_info
    puts "#{human.name} is an #{human.marker} " \
         "with a score of #{human.score}"
    puts "#{computer.name} is an #{computer.marker} " \
         "with a score of #{computer.score}"
  end

  def current_player_moves
    player_turn_order.first == human ? human_moves : computer_moves
    set_next_player_turn
  end

  def set_next_player_turn
    player_turn_order.reverse!
  end

  def human_moves
    input = nil
    formatted_output = joiner(board.empty_square_positions).join(', ')
    loop do
      print "Choose a square from #{formatted_output}: "
      input = gets.chomp.to_i
      break if board.empty_square_positions.include?(input)
      puts 'Sorry, that is not a valid choice...'
    end
    board[input] = human.marker
  end

  def joiner(array)
    array[-1] = ('or ' + array[-1].to_s) if array.size > 1
    array
  end

  def computer_moves
    input = board.empty_square_positions.to_a.sample
    board[input] = computer.marker
  end

  def round_winner?
    !!winning_player
  end

  def winning_player
    player_turn_order.each do |player|
      WINNING_LINES.each do |line|
        if line.all? { |pos| board.squares[pos].marker == player.marker }
          return player
        end
      end
    end
    nil
  end

  def game_winner?
    return false unless round_winner?
    winning_player.score >= WINNING_SCORE
  end

  def adjust_scores
    winning_player.increment_score if round_winner?
  end

  def display_result
    display_board

    if board.full? && !round_winner?
      puts "It's a tie!"
    else
      puts "The round winner is #{winning_player}!"
    end
  end

  def display_game_winner
    puts "The winner of #{WINNING_SCORE} rounds is #{winning_player}!"
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

  def continue
    puts
    print 'Hit RETURN to continue...'
    gets
  end

  def reset_round
    board.reset
  end

  def reset_game
    board.reset
    human.score_reset
    computer.score_reset
  end
end

game = TTTGame.new
game.play
