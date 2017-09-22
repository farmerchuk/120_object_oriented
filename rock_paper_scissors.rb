class Player
  attr_accessor :sign, :name, :score, :history

  def initialize
    @score = 0
    @history = []
  end

  def favorite_sign
    return nil if history.empty?
    counts = Hash.new 0
    history.each { |sign| counts[sign.to_s] += 1  }
    counts.max_by { |_, count| count }.first
  end

  def add_sign_to_history
    self.history << sign
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
      print "Please choose from: #{Sign::SIGNS.join(', ')}: "
      choice = gets.chomp
      break if Sign::SIGNS.include? choice
      puts 'Sorry, that is not a valid option!'
    end
    self.sign = Sign.create(choice)
    add_sign_to_history
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'C3PO', 'Walle', 'Chappie'].sample
  end

  def choose(player_fav_sign)
    if player_fav_sign.nil?
      self.sign = Sign.create(Sign::SIGNS.sample)
      add_sign_to_history
    else
      self.sign = Sign.create(Sign::WINNING_SIGNS[player_fav_sign].sample)
      add_sign_to_history
    end
  end
end

class Sign
  SIGNS = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  WINNING_SIGNS = {
    'rock' => ['paper', 'spock'],
    'paper' => ['lizard', 'scissors'],
    'scissors' => ['rock', 'spock'],
    'lizard' => ['rock', 'scissors'],
    'spock' => ['lizard', 'paper'],
  }

  def self.create(value)
    return Rock.new if value == 'rock'
    return Paper.new if value == 'paper'
    return Scissors.new if value == 'scissors'
    return Lizard.new if value == 'lizard'
    return Spock.new if value == 'spock'
  end

  def to_s
    self.class.to_s.downcase
  end
end

class Rock < Sign
  def >(other_sign)
    other_sign.class == Scissors || other_sign.class == Lizard
  end
end

class Paper < Sign
  def >(other_sign)
    other_sign.class == Rock || other_sign.class == Spock
  end
end

class Scissors < Sign
  def >(other_sign)
    other_sign.class == Paper || other_sign.class == Lizard
  end
end

class Lizard < Sign
  def >(other_sign)
    other_sign.class == Paper || other_sign.class == Spock
  end
end

class Spock < Sign
  def >(other_sign)
    other_sign.class == Rock || other_sign.class == Scissors
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
    puts 'Welcome to Rock, Paper, Scissors, Lizard, Spock!'
  end

  def display_goodbye_message
    puts 'Thanks for playing Rock, Paper, Scissors, Lizard, Spock!'
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
        computer.choose(human.favorite_sign)
        human.choose
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
