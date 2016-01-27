class Card
  def initialize(rank, suit)
  @rank = rank
  @suit = suit
  end
  attr_reader :rank
  attr_reader :suit
  def rank_to_number
    case @rank
          when :ace then 14
          when :king then 13
          when :queen then 12
          when :jack then 11
          else @rank
        end
  end
  def to_s
    if rank_to_number > 10
      @rank.capitalize.to_s + " of " + @suit.capitalize.to_s
        else @rank.to_s + " of " + @suit.capitalize.to_s
        end
  end
  def ==(card)
    @rank == card.rank and @suit == card.suit
  end
  def <=>(card)
    if @suit.to_s[0].ord != card.suit.to_s[0].ord
        @suit.to_s[0].ord <=> card.suit.to_s[0].ord
        else rank_to_number <=> card.rank_to_number
        end
  end
  def to_belote
    BeloteCard.new(@rank, @suit)
  end
end

class BeloteCard < Card
  def rank_to_number
    case @rank
          when :ace then 14
          when :king then 12
          when :queen then 11
          when :jack then 10
          when 10 then 13
          else @rank
        end
  end
end

class Deck
  include Enumerable
  def basic_deck
    array_of_cards = []
        count = 1
        while count <= 52
          card = Card.new(number_to_rank(count % 13 + 2),number_to_suit(count % 4))
          array_of_cards << card
          count += 1
        end
        array_of_cards
  end
  def initialize(array_of_cards = basic_deck)
    @cards = array_of_cards.dup
  end
  def each
    counter = 0
        while counter < @cards.size
          yield @cards[counter]
          counter += 1
        end
  end
  def size
    @cards.size
  end
  def draw_top_card
    @cards.pop
  end
  def draw_bottom_card
    @cards.shift
  end
  def top_card
    @cards[-1]
  end
  def bottom_card
    @cards[0]
  end
  def to_s
    counter = 0
        string = ""
        while counter < @cards.size
          string = string + @cards[counter].to_s + "\n"
          counter += 1
        end
        string
  end
  def sort
    @cards.sort!.reverse!
  end
  def shuffle
    @cards.shuffle!
  end
  def number_to_rank(number)
    case number
          when 14 then :ace
          when 13 then :king
          when 12 then :queen
          when 11 then :jack
          else number
    end
  end
  def number_to_suit(number)
    case number
          when 3 then :spades
          when 2 then :hearts
          when 1 then :diamonds
          else :clubs
    end
end
end

class WarDeck < Deck
  def deal
    dealt_cards, counter = [], 0
        while counter < 26
          dealt_cards << draw_top_card
          counter += 1
        end
        PlayerWarDeck.new(dealt_cards)
  end
end

class PlayerWarDeck < Deck
  def play_card
    draw_bottom_card
  end
  def allow_face_up?
    size <= 3
  end
end

class BeloteDeck < Deck
  def basic_deck
    array_of_cards, count = [], -1
        while (count += 1) < 8
          array_of_cards << BeloteCard.new(number_to_rank(count % 8 + 7),:spades)
          array_of_cards << BeloteCard.new(number_to_rank(count % 8 + 7),:diamonds)
          array_of_cards << BeloteCard.new(number_to_rank(count % 8 + 7),:hearts)
          array_of_cards << BeloteCard.new(number_to_rank(count % 8 + 7),:clubs)
        end
    array_of_cards
  end
  def initialize(array_of_cards = basic_deck)
    counter = 0
    while counter < array_of_cards.size
          array_of_cards[counter] = array_of_cards[counter].to_belote
          counter += 1
        end
    @cards = array_of_cards.dup
  end
  def deal
    dealt_cards, counter = [], 0
        while counter < 8
          dealt_cards << draw_top_card
          counter += 1
        end
        PlayerBeloteDeck.new(dealt_cards)
  end
  def sort
    @cards.sort!.reverse!
  end
end

class PlayerBeloteDeck < BeloteDeck
  def carre_of_jacks?
    @cards.select{|card| card.rank == :jack}.size == 4
  end
  def carre_of_nines?
    @cards.select{|card| card.rank == 9}.size == 4
  end
  def carre_of_aces?
    @cards.select{|card| card.rank == :ace}.size == 4
  end
  def highest_of_suit(suit)
    @cards.select{|card| card.suit == suit}.max
  end
  def belote_from_suit(suit)
    has_queen = @cards.any? {|card| card == Card.new(:queen,suit)}
        has_king = @cards.any? {|card| card == Card.new(:king,suit)}
        has_king and has_queen
  end
  def belote?
    minor_belote = (belote_from_suit(:clubs) or belote_from_suit(:diamonds))
        major_belote = (belote_from_suit(:hearts) or belote_from_suit(:spades))
        minor_belote or major_belote
  end
  def max_sequence(suit)
    cards = @cards.select{|card| card.suit == suit}
        max_count, count, counter = 0, 1, 0
        while counter < cards.size - 1
          if (cards[counter].rank_to_number - 1) == cards[counter + 1].rank_to_number
            count, counter = count + 1, counter + 1
          else max_count, count, counter = [max_count, count].max, 1, counter + 1
          end
        end
        max_count
  end
  def tierce?
    self.sort
    if (max_sequence(:spades) >= 3) or (max_sequence(:diamonds) >= 3)
          true
        elsif (max_sequence(:clubs) >= 3) or (max_sequence(:hearts) >= 3)
          true
        else false
        end
  end
  def quarte?
    self.sort
    if (max_sequence(:spades) >= 4) or (max_sequence(:diamonds) >= 4)
          true
        elsif (max_sequence(:clubs) >= 4) or (max_sequence(:hearts) >= 4)
          true
        else false
        end
  end
  def quint?
    self.sort
    if (max_sequence(:spades) >= 5) or (max_sequence(:diamonds) >= 5)
          true
        elsif (max_sequence(:clubs) >= 5) or (max_sequence(:hearts) >= 5)
          true
        else false
        end
  end
end

class SixtySixDeck < Deck
  def deal
    dealt_cards, counter = [], 0
        while counter < 6
          dealt_cards << draw_top_card
          counter += 1
        end
        PlayerSixtySixDeck.new(dealt_cards)
  end
  def basic_deck
    array_of_cards, count = [], -1
        while (count += 1) < 6
          array_of_cards << BeloteCard.new(number_to_rank(count % 8 + 9),:spades)
          array_of_cards << BeloteCard.new(number_to_rank(count % 8 + 9),:diamonds)
          array_of_cards << BeloteCard.new(number_to_rank(count % 8 + 9),:hearts)
          array_of_cards << BeloteCard.new(number_to_rank(count % 8 + 9),:clubs)
        end
    array_of_cards
  end
  def initialize(array_of_cards = basic_deck)
    counter = 0
    while counter < array_of_cards.size
          array_of_cards[counter] = array_of_cards[counter].to_belote
          counter += 1
        end
    @cards = array_of_cards.dup
  end
end

class PlayerSixtySixDeck < SixtySixDeck
  def forty?(trump_suit)
    has_queen = @cards.any? {|card| card == Card.new(:queen,trump_suit)}
        has_king = @cards.any? {|card| card == Card.new(:king,trump_suit)}
        has_king and has_queen
  end
  def twenty?(trump_suit)
    first_suit, second_suit = false, false
        third_suit, forth_suit = false, false
        first_suit = (forty?(:spades) and :spades != trump_suit)
        second_suit = (forty?(:diamonds) and :diamonds != trump_suit)
        third_suit = (forty?(:hearts) and :hearts != trump_suit)
        forth_suit = (forty?(:clubs) and :clubs != trump_suit)
        first_suit or second_suit or third_suit or forth_suit
  end
end
