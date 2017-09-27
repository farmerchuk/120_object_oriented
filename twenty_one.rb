class Player
  attr_reader :name, :hand

  def initialize(name)
    @name = name
    @hand = []
  end

  def hit(card)
    hand << card
  end

  def display_hand
    puts "#{name} has these cards:"
    hand.each { |card| puts card.to_s }
    puts
  end

  def busted?
    hand_value > 21
  end

  private

  def hand_value
    hand.map(&:value).reduce(:+)
  end
end

class Dealer < Player
  MAX_VALUE = 17

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
    display_table
    dealer_turn
    display_table
    # show_result
  end

  private

  attr_reader :deck, :player, :dealer

  def clear
    system 'clear'
  end

  def welcome_message
    clear
    puts "Welcome to Twenty-One!"
    puts
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
  end

  def dealer_turn
    loop do
      break if player.busted?
      dealer.busted? || dealer.stay? ? break : dealer.hit(deck.deal_card)
      display_table
      sleep 1
    end
  end

  def hit?
    print 'Would you like another card? (y/n): '
    choice = gets.chomp.downcase
    choice == 'y'
  end
end

Game.new.start
