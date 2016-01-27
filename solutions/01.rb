def round_to_second_digit(price)
  price = price * 100
  remainder = price % 1
  if remainder >= 0.5
    round_price = price.ceil / 100.0
  else
    round_price = price.floor / 100.0
  end
  round_price
end
def convert_to_bgn(price, currency)
  if currency == :usd
    round_to_second_digit(price * 1.7408)
  elsif currency == :eur
    round_to_second_digit(price * 1.9557)
  elsif currency == :gbp
    round_to_second_digit(price * 2.6415)
  else
    price
  end
end
def compare_prices(first_price, first_currency, second_price, second_currency)
  first_price_bgn = convert_to_bgn(first_price, first_currency)
  second_price_bgn = convert_to_bgn(second_price, second_currency)
  first_price_bgn - second_price_bgn
end
