class Player
  attr_accessor :sign, :name

  def initialize(player_type = :human)
    @player_type = player_type
    @sign = nil
    @name = nil
  end

  def set_name
    if human?
      name = nil
      loop do
        print 'What is your name? '
        name = gets.chomp
        break unless name.empty?
        puts 'Please enter a name!'
      end
      self.name = name
    else
      self.name = ['R2D2', 'C3PO', 'Walle', 'Chappie'].sample
    end
  end

  def choose
    if human?
      choice = nil
      loop do
        print 'Please choose rock, paper or scissors: '
        choice = gets.chomp
        break if ['paper', 'rock', 'scissors'].include? choice
        puts 'Sorry, that is not a valid option!'
      end
      self.sign = choice
    else
      self.sign = ['rock', 'paper', 'scissors'].sample
    end
  end

  def human?
    @player_type == :human
  end
end

class Sign
  def initialize
    # seems like we need something to keep track
    # of the choice... a sign object can be "paper", "rock" or "scissors"
  end
end

class Rule
  def initialize
    # not sure what the "state" of a rule object should be
  end
end

# not sure where "compare" goes yet
def compare(move1, move2)

end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new(:computer)
  end

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors!'
  end

  def display_goodbye_message
    puts 'Thanks for playing Rock, Paper, Scissors!'
  end

  def display_winner
    puts "#{human.name} chose: #{human.sign}"
    puts "#{computer.name} chose: #{computer.sign}"
    case
    when human.sign == computer.sign
      puts "It's a tie!"
    when human.sign == 'rock' && computer.sign == 'scissors' ||
         human.sign == 'paper' && computer.sign == 'rock' ||
         human.sign == 'scissors' && computer.sign == 'paper'
      puts "#{human.name} wins!"
    else
      puts "#{computer.name} wins!"
    end
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

  def play
    display_welcome_message
    loop do
      human.set_name
      computer.set_name
      human.choose
      computer.choose
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
