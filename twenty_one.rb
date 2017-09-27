class Player
  attr_reader :name, :hand

  def initialize(name)
    @name = name
    @hand = []
  end

  def hit
  end

  def stay
  end

  def hand_value

  end

  def display_hand
    puts "#{name} has these cards:"
    hand.each { |card| puts card.to_s }
    puts
  end

  def busted?
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
    @dealer = Player.new('Dealer')
  end

  def start
    welcome_message
    deal_cards
    show_initial_cards
    # player_turn
    # dealer_turn
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

  def show_initial_cards
    player.display_hand
    dealer.display_hand
  end
end

Game.new.start
