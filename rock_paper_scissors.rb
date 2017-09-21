class Player
  attr_accessor :sign

  def initialize(player_type = :human)
    @player_type = player_type
    @sign = nil
  end

  def choose
    if human?
      choice = nil
      loop do
        print 'Please choose rock, paper or scissors: '
        choice = gets.chomp
        break if ['paper', 'rock', 'scissors'].include?(choice)
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

  def play
    display_welcome_message
    human.choose
    computer.choose
    display_winner
    display_goodbye_message
  end
end

RPSGame.new.play
