class RationalSequence
  include Enumerable
  def initialize(limit)
    @limit = limit
  end
  def each
    sign, count, numerator, denominator  = 1, 0, 1, 1
    while count < @limit
      new_rational = Rational(numerator, denominator)
      if new_rational.numerator + new_rational.denominator == numerator + denominator
        yield(Rational(numerator, denominator))
            count = count + 1
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
    count, current_number = 0, 2
    while count < @limit
          if DrunkenMathematician.prime?(current_number)
            yield current_number
                count = count + 1
          end
        current_number = current_number + 1
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
    previous, current, count = @first.values[0], @second.values[0], 0
    while count < @limit
      yield previous
      current, previous = current + previous, current
          count = count + 1
    end
  end
end

module DrunkenMathematician
  module_function

  def prime?(integer)
    count = 2
    while count <= Math.sqrt(integer) and integer % count > 0
          count = count + 1
    end
    if (integer % count == 0 and integer != 2) or integer == 1
          false
    else
          true
    end
  end

  def meaningless(n)
    rational_array = RationalSequence.new(n).to_a
        group_1, group_2 = [], []
        rational_array.each do |k|
      if DrunkenMathematician.prime?(k.numerator) or DrunkenMathematician.prime?(k.denominator)
            group_1 << k
          else
            group_2 << k
          end
        end
        product = 1
        group_1.each { |k| product = product * k }
        group_2.each { |k| product = product / k }
        product
  end

  def aimless(n)
    prime_array = PrimeSequence.new(n).to_a
        rational_array = []
        if prime_array.size.odd?
          prime_array << 1
        end
        position = 0
        while position < prime_array.size
          rational_array << Rational(prime_array[position],prime_array[position+1])
          position = position + 2
        end
        sum = 0
        rational_array.each { |k| sum = sum + k }
        sum
  end

  def worthless(n)
    number = FibonacciSequence.new(n).max
        sum = 0
        RationalSequence.new(Float::INFINITY).lazy.take_while{|k| sum += k and sum <= number}.force
  end
end
