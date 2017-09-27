class Player
  def initialize
    # what would the "data" or "states" of a Player object entail?
    # maybe cards? a name?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
    # definitely looks like we need to know about "cards" to produce some total
  end
end

class Dealer
  def initialize
    # seems like very similar to Player... do we even need this?
  end

  def deal
    # does the dealer or the deck deal?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

class Participant
  # what goes in here? all the redundant behaviors from Player and Dealer?
end

class Deck
  SUITS = %w[HEARTS DIAMONDS SPADES CLUBS]
  NAMES = %w[2 3 4 5 6 7 8 9 10 JACK QUEEN KING ACE]

  attr_reader :cards

  def initialize
    @cards = new_deck_of_cards
  end

  def new_deck_of_cards
    SUITS.each_with_object([]) do |suit, cards|
      NAMES.each do |name|
        value = name.to_i
        value = Card::FACE_VALUE if value == 0
        value = Card::ACE_VALUE if name == 'ACE'
        cards << Card.new(name, suit, value)
      end
    end
  end

  def deal_card

  end
end

class Card
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
    @deck
    @player
    @dealer
  end

  def start
    Deck.new.cards.each {|card| puts card.to_s}
    # deal_cards
    # show_initial_cards
    # player_turn
    # dealer_turn
    # show_result
  end

  private

end

Game.new.start
