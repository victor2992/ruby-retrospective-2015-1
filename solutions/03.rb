class Numeric
  def prime?
    (1..self / 2).one? { |remainder| self % remainder == 0 }
  end
end

class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    sign, count, numerator, denominator = 1, 0, 1, 1
    while count < @limit
      new_rational = Rational(numerator, denominator)
      if new_rational.numerator + new_rational.denominator == numerator + denominator
        yield Rational(numerator, denominator)
        count += 1
      end
      if denominator == 1 and numerator.odd?
        numerator, sign = numerator + 1, -1
      elsif numerator == 1 and denominator.even?
        denominator, sign = denominator + 1, 1
      else
        numerator, denominator = numerator + sign, denominator - sign
      end
    end
  end
end

class PrimeSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    count = 0
    current_number = 2
    while count < @limit
      if current_number.prime?
        yield current_number
        count += 1
      end
      current_number += 1
    end
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(limit, first = {first: 1}, second = {second: 1})
    @limit = limit
    @first = first
    @second = second
  end

  def each
    previous = @first[:first]
    current = @second[:second]
    count = 0
    while count < @limit
      yield previous
      current, previous = current + previous, current
      count += 1
    end
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    rational_array = RationalSequence.new(n).to_a
    group_1 = [1]
    group_2 = [1]
    rational_array.each do |rational|
      if rational.numerator.prime? or rational.denominator.prime?
        group_1 << rational
      else group_2 << rational
      end
    end
    group_1.reduce(:*) / group_2.reduce(:*)
  end

  def aimless(n)
    pairs = PrimeSequence.new(n).each_slice(2).to_a
    pairs.last << 1 if n.odd?
    rationals = pairs.map { |pair| Rational(pair[0], pair[1]) }
    rationals.reduce(:+)
  end

  def worthless(n)
    number = FibonacciSequence.new(n).max
    sum = 0
    RationalSequence.new(Float::INFINITY).lazy.take_while do |rational|
      sum += rational and sum <= number
    end.force
  end
end
