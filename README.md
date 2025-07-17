# Acme Widget Co - Sales System

A proof of concept for Acme Widget Co's new sales system. This implements a shopping basket that calculates totals based on product prices, delivery costs, and special offers.

## How it works

The system calculates basket totals by:
1. Adding up product prices
2. Applying any special offers/discounts
3. Adding delivery costs based on the final amount

## Products

| Product | Code | Price |
|---------|------|-------|
| Red Widget | R01 | $32.95 |
| Green Widget | G01 | $24.95 |
| Blue Widget | B01 | $7.95 |

## Delivery Costs

- Orders under $50: $4.95
- Orders under $90: $2.95
- Orders $90 or more: Free

## Special Offers

- Buy one red widget, get the second half price

## Usage

```ruby
require_relative 'lib/basket_factory'

# Create a basket
basket = BasketFactory.create_default_basket

# Add products
basket.add('R01')  # Red Widget
basket.add('G01')  # Green Widget

# Get total
total = basket.total
puts "Total: $#{'%.2f' % total}"
```

## Running

Test the system:
```bash
ruby main.rb
```

Run tests:
```bash
ruby test/basket_test.rb
ruby test/delivery_calculator_test.rb
ruby test/offer_calculator_test.rb
```

## Test Cases

The system correctly calculates these totals:

| Products | Total |
|----------|-------|
| B01, G01 | $37.85 |
| R01, R01 | $54.37 |
| R01, G01 | $60.85 |
| B01, B01, R01, R01, R01 | $98.27 |

## Assumptions

- The "buy one get one half price" offer applies to pairs of red widgets
- Delivery is calculated after discounts are applied
- Product codes are case-sensitive