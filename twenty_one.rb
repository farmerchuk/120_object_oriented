module Hand
  attr_reader :hand

  def display_hand
    puts "#{name} has these cards:"
    hand.each { |card| puts card.to_s }
    puts "Total value of: #{hand_value}"
    puts
  end

  def hand_value
    aces = hand.count { |card| card.name == 'ACE'}
    value = hand.map(&:value).reduce(:+)
    return value if aces == 0
    ace_adjusted_value(value, aces) if (value > 21) && (aces > 0)
  end

  private

  def ace_adjusted_value(value, num_of_aces)
    return value if (num_of_aces == 0) || (value <= 21)
    ace_adjusted_value(value - 10, num_of_aces - 1)
  end
end

class Player
  include Hand

  attr_reader :name

  def initialize(name)
    @name = name
    @hand = []
  end

  def hit(card)
    hand << card
  end

  def busted?
    hand_value > 21
  end
end

class Dealer < Player
  MAX_VALUE = 17

  def hit(card)
    puts "#{name} is drawing a card..."
    sleep 2
    super
  end

  def stay?
    hand_value >= MAX_VALUE
  end
end

class Deck
  def initialize
    @cards = new_deck_of_cards
    shuffle_cards
  end

  def deal_card
    cards.pop
  end

  private

  attr_reader :cards

  def new_deck_of_cards
    Card::SUITS.each_with_object([]) do |suit, cards|
      Card::NAMES.each do |name|
        value = name.to_i
        value = Card::FACE_VALUE if value == 0
        value = Card::ACE_VALUE if name == 'ACE'
        cards << Card.new(name, suit, value)
      end
    end
  end

  def shuffle_cards
    5.times { cards.shuffle! }
  end
end

class Card
  SUITS = %w[HEARTS DIAMONDS SPADES CLUBS]
  NAMES = %w[2 3 4 5 6 7 8 9 10 JACK QUEEN KING ACE]
  FACE_VALUE = 10
  ACE_VALUE = 11

  attr_reader :name, :suit, :value

  def initialize(name, suit, value)
    @name = name
    @suit = suit
    @value = value
  end

  def to_s
    "#{name} of #{suit}"
  end
end

class Game
  def initialize
    @deck = Deck.new
    @player = Player.new('Jason')
    @dealer = Dealer.new('Dealer')
  end

  def start
    welcome_message
    deal_cards
    display_table
    player_turn
    dealer_turn
    display_results
  end

  private

  attr_reader :deck, :player, :dealer

  def clear
    system 'clear'
  end

  def welcome_message
    clear
    puts '         Welcome to Twenty-One!'
    puts '-----------------------------------------'
    puts
    puts "You'll be dealt two cards to start."
    puts
    puts 'Request additional cards from the dealer'
    puts "until you're happy with your hand, or"
    puts 'you bust.'
    puts
    puts "Compare your hand against the dealer's"
    puts 'hand to see who wins!'
    puts
    print 'Press RETURN to continue...'
    gets
  end

  def deal_cards
    2.times { player.hand << deck.deal_card }
    2.times { dealer.hand << deck.deal_card }
  end

  def display_table
    clear
    player.display_hand
    dealer.display_hand
  end

  def player_turn
    loop do
      hit? ? player.hit(deck.deal_card) : break
      break if player.busted?
      display_table
    end
    display_table
  end

  def dealer_turn
    loop do
      break if player.busted?
      (dealer.busted? || dealer.stay?) ? break : dealer.hit(deck.deal_card)
      display_table
      sleep 1
    end
    display_table
  end

  def hit?
    print 'Would you like another card? (y/n): '
    choice = gets.chomp.downcase
    choice == 'y'
  end

  def display_results
    if player.busted?
      puts 'Sorry, you busted! Dealer wins the round.'
    elsif dealer.busted?
      puts 'Dealer busted. You win the round!'
    elsif player.hand_value > dealer.hand_value
      puts 'You have the best hand. You win the round!'
    elsif dealer.hand_value > player.hand_value
      puts 'Dealer has the best hand. Dealer wins the round.'
    elsif dealer.hand_value == player.hand_value
      puts "It's a tie! No one wins the round."
    end
  end
end

Game.new.start
