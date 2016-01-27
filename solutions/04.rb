class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    @rank.to_s.capitalize + " of " + @suit.to_s.capitalize
  end

  def ==(card)
    rank == card.rank && suit == card.suit
  end

  def rank_to_number
    hash_with_ranks = {ace: 14, king: 13, queen: 12, jack: 11}
    return rank if (2..10).include? rank
    hash_with_ranks[rank]
  end

  def <=>(card)
    return suit <=> card.suit if suit != card.suit
    rank_to_number <=> card.rank_to_number
  end
end

class Deck
  include Enumerable

  def ranks
    [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  end

  def suits
    [:clubs, :diamonds, :hearts, :spades]
  end

  def full_deck
    suits.product(ranks).map { |suit, rank| Card.new(rank, suit) }
  end

  def initialize(cards = full_deck)
    @cards = cards
  end

  def each
    @cards.each { |card| yield card }
  end

  def size
    @cards.size
  end

  def draw_top_card
    @cards.shift
  end

  def draw_bottom_card
    @cards.pop
  end

  def top_card
    @cards.first
  end

  def bottom_card
    @cards.last
  end

  def shuffle
    @cards.shuffle!
  end

  def sort
    @cards.sort!.reverse!
  end

  def to_s
    @cards.reduce("") { |result, card| result += card.to_s + "\n" }
  end

  def deal
    Hand.new([])
  end
end

class Hand
  def initialize(cards)
    @cards = cards
  end

  def size
    @cards.size
  end
end

class WarDeckHand < Hand
  def play_card
    @cards.shift
  end

  def allow_face_up?
    size <= 3
  end
end

class WarDeck < Deck
  def deal
    hand = []
    1.upto(26) { hand << draw_top_card }
    WarDeckHand.new(hand)
  end
end

class BeloteDeckHand < Hand
  def highest_of_suit(suit)
    @cards.select { |card| card.suit == suit }.max
  end

  def belote?
    [:clubs, :diamonds, :hearts, :spades].map do |suit|
      @cards.any? { |card| card == Card.new(:queen, suit) } and
        @cards.any? { |card| card == Card.new(:king, suit) }
    end.reduce(false) { |result, predicate| result or predicate }
  end

  def consecutive?(length)
    @cards.sort.each_cons(length).any? do |group|
      group.first.suit == group.last.suit &&
        group.last.rank_to_number - group.first.rank_to_number == length - 1
    end
  end

  def tierce?
    consecutive?(3)
  end

  def quarte?
    consecutive?(4)
  end

  def quint?
    consecutive?(5)
  end

  def carre?(rank)
    @cards.select { |card| card.rank == rank }.size == 4
  end

  def carre_of_jacks?
    carre?(:jack)
  end

  def carre_of_nines?
    carre?(9)
  end

  def carre_of_aces?
    carre?(:ace)
  end
end

class BeloteDeck < Deck
  def ranks
    [7, 8, 9, 10, :jack, :queen, :king, :ace]
  end

  def deal
    hand = []
    1.upto(8) { hand << draw_top_card }
    BeloteDeckHand.new(hand)
  end
end

class SixtySixHand < Hand
  def twenty?(trump_suit)
    ([:clubs, :diamonds, :hearts, :spades] - [trump_suit]).map do |suit|
      @cards.any? { |card| card == Card.new(:queen, suit) } and
        @cards.any? { |card| card == Card.new(:king, suit) }
    end.reduce(false) { |result, predicate| result or predicate }
  end

  def forty?(trump_suit)
    @cards.any? { |card| card == Card.new(:queen, trump_suit) } and
      @cards.any? { |card| card == Card.new(:king, trump_suit) }
  end
end

class SixtySixDeck < Deck
  def ranks
    [9, 10, :jack, :queen, :king, :ace]
  end

  def deal
    hand = []
    1.upto(6) { hand << draw_top_card }
    SixtySixHand.new(hand)
  end
end
