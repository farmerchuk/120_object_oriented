class Player
  attr_accessor :sign, :name, :score

  def initialize
    @score = 0
  end
end

class Human < Player
  def set_name
    name = nil
    loop do
      print 'What is your name? '
      name = gets.chomp
      break unless name.empty?
      puts 'Please enter a name!'
    end
    self.name = name
  end

  def choose
    choice = nil
    loop do
      print 'Please choose rock, paper or scissors: '
      choice = gets.chomp
      break if Sign::SIGNS.include? choice
      puts 'Sorry, that is not a valid option!'
    end
    self.sign = Sign.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'C3PO', 'Walle', 'Chappie'].sample
  end

  def choose
    self.sign = Sign.new(Sign::SIGNS.sample)
  end
end

class Sign
  SIGNS = ['rock', 'paper', 'scissors']

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def rock?
    value == 'rock'
  end

  def paper?
    value == 'paper'
  end

  def scissors?
    value == 'scissors'
  end

  def >(other_sign)
    rock? && other_sign.scissors? || paper? && other_sign.rock? ||
      scissors? && other_sign.paper?
  end

  def to_s
    value
  end
end

class RPSGame
  MAX_SCORE = 5

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors!'
  end

  def display_goodbye_message
    puts 'Thanks for playing Rock, Paper, Scissors!'
  end

  def display_moves
    puts "#{human.name} chose: #{human.sign}"
    puts "#{computer.name} chose: #{computer.sign}"
  end

  def determine_winner
    if human.sign > computer.sign
      human
    elsif computer.sign > human.sign
      computer
    else
      nil
    end
  end

  def update_player_points
    winner = determine_winner
    return if winner.nil?
    winner.score += 1
  end

  def game_winner?
    human.score == MAX_SCORE || computer.score == MAX_SCORE
  end

  def determine_game_winner
    return nil unless game_winner?
    human.score == MAX_SCORE ? human : computer
  end

  def display_round_winner
    winner = determine_winner
    if winner == human
      puts "#{human.name} wins!"
    elsif winner == computer
      puts "#{computer.name} wins!"
    else
      puts "It's a tie!"
    end
  end

  def display_game_winner
    game_winner = determine_game_winner
    puts "#{game_winner.name} wins the game!"
  end

  def display_player_points
    puts "#{human.name} has #{human.score} point(s)."
    puts "#{computer.name} has #{computer.score} point(s)."
  end

  def play_again?
    choice = nil
    loop do
      print 'Would you like to play again? (y/n) '
      choice = gets.chomp
      break if ['y', 'n'].include? choice
      puts 'Sorry, that is not a valid option!'
    end
    choice == 'y' ? true : false
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def play
    display_welcome_message
    human.set_name
    computer.set_name
    loop do
      loop do
        human.choose
        computer.choose
        update_player_points
        display_moves
        display_round_winner
        display_player_points
        break if game_winner?
      end
      display_game_winner
      break unless play_again?
      reset_scores
    end
    display_goodbye_message
  end
end

RPSGame.new.play
