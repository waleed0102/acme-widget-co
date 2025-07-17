#!/usr/bin/env ruby

require_relative 'lib/basket_factory'

def test_basket(product_codes)
  basket = BasketFactory.create_default_basket

  product_codes.each do |code|
    basket.add(code)
  end

  total = basket.total
  puts "Products: #{product_codes.join(', ')}"
  puts "Total: $#{'%.2f' % total}"
  puts "---"
end

puts "Acme Widget Co - Sales System Test Cases"
puts "========================================"
puts

# Test cases from the requirements
test_basket(['B01', 'G01'])      # Expected: $37.85
test_basket(['R01', 'R01'])      # Expected: $54.37
test_basket(['R01', 'G01'])      # Expected: $60.85
test_basket(['B01', 'B01', 'R01', 'R01', 'R01'])  # Expected: $98.27