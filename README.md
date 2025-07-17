# Acme Widget Co - Sales System

A proof of concept for Acme Widget Co's new sales system, implementing a shopping basket with delivery cost rules and special offers.

## Overview

This system implements a shopping basket that calculates totals based on:
- Product prices from a catalogue
- Delivery cost rules based on order value
- Special offers and discounts

## Architecture

The solution follows good software engineering principles with:

### Separation of Concerns
- **Basket**: Main orchestrator that manages items and calculates totals
- **ProductCatalogue**: Manages available products
- **DeliveryCalculator**: Handles delivery cost calculations using strategy pattern
- **OfferCalculator**: Manages multiple offers and calculates total discounts
- **Product**: Value object representing individual products

### Dependency Injection
All dependencies are injected into the Basket constructor, making it easy to test and configure different scenarios.

### Strategy Pattern
- Delivery rules are configurable through the DeliveryCalculator
- Offers are pluggable through the OfferCalculator
- New offer types can be easily added by implementing the BaseOffer interface

## Products

| Product | Code | Price |
|---------|------|-------|
| Red Widget | R01 | $32.95 |
| Green Widget | G01 | $24.95 |
| Blue Widget | B01 | $7.95 |

## Delivery Rules

- Orders under $50: $4.95 delivery
- Orders under $90: $2.95 delivery  
- Orders $90 or more: Free delivery

## Special Offers

Currently implemented:
- **Buy One Get One Half Price**: Buy one red widget, get the second half price

## Usage

### Basic Usage

```ruby
require_relative 'lib/basket_factory'

# Create a basket with default configuration
basket = BasketFactory.create_default_basket

# Add products
basket.add('R01')  # Red Widget
basket.add('G01')  # Green Widget

# Calculate total
total = basket.total
puts "Total: $#{'%.2f' % total}"
```

### Custom Configuration

```ruby
require_relative 'lib/basket'
require_relative 'lib/product_catalogue'
require_relative 'lib/delivery_calculator'
require_relative 'lib/offer_calculator'

# Create custom product catalogue
catalogue = ProductCatalogue.new
catalogue.add_product(Product.new('CUSTOM', 'Custom Widget', 19.99))

# Create custom delivery rules
delivery_rules = [
  { threshold: 30, cost: 3.50 },
  { threshold: 60, cost: 1.50 }
]
delivery_calculator = DeliveryCalculator.new(delivery_rules)

# Create offer calculator with custom offers
offer_calculator = OfferCalculator.new
offer_calculator.add_offer(BuyOneGetOneHalfPrice.new('CUSTOM'))

# Create basket with custom configuration
basket = Basket.new(catalogue, delivery_calculator, offer_calculator)
```

## Running the Application

### Run Test Cases
```bash
ruby main.rb
```

### Run Unit Tests
```bash
ruby test/basket_test.rb
ruby test/delivery_calculator_test.rb
ruby test/offer_calculator_test.rb
```

## Test Cases

The system includes the following test cases from the requirements:

| Products | Expected Total |
|----------|----------------|
| B01, G01 | $37.85 |
| R01, R01 | $54.37 |
| R01, G01 | $60.85 |
| B01, B01, R01, R01, R01 | $98.27 |

## Assumptions

1. **Offer Application**: The "buy one get one half price" offer applies to pairs of items. For odd numbers, the extra item is charged at full price.

2. **Delivery Calculation**: Delivery cost is calculated on the subtotal after discounts are applied.

3. **Product Codes**: Product codes are case-sensitive and must match exactly.

4. **Price Precision**: All calculations use floating-point arithmetic with rounding to 2 decimal places for display.

5. **Immutable Products**: Products are treated as value objects and should not be modified after creation.

## Extensibility

### Adding New Offers

To add a new offer type:

1. Create a new class that inherits from `BaseOffer`
2. Implement the `calculate_discount(items)` method
3. Add the offer to the `OfferCalculator`

Example:
```ruby
class BuyTwoGetOneFree < BaseOffer
  def initialize(product_code)
    @product_code = product_code
  end

  def calculate_discount(items)
    matching_items = items.select { |item| item.code == @product_code }
    return 0 if matching_items.length < 3

    groups_of_three = matching_items.length / 3
    groups_of_three * matching_items.first.price
  end
end
```

### Adding New Delivery Rules

Delivery rules can be customized by passing a different rules array to the `DeliveryCalculator`:

```ruby
custom_rules = [
  { threshold: 25, cost: 5.00 },
  { threshold: 75, cost: 3.00 }
]
delivery_calculator = DeliveryCalculator.new(custom_rules)
```

## File Structure

```
├── lib/
│   ├── basket.rb                    # Main basket class
│   ├── product.rb                   # Product value object
│   ├── product_catalogue.rb         # Product management
│   ├── delivery_calculator.rb       # Delivery cost calculation
│   ├── offer_calculator.rb          # Offer management
│   ├── basket_factory.rb            # Factory for easy setup
│   └── offers/
│       ├── base_offer.rb            # Base offer interface
│       └── buy_one_get_one_half_price.rb  # Specific offer implementation
├── test/
│   ├── basket_test.rb               # Basket unit tests
│   ├── delivery_calculator_test.rb  # Delivery calculator tests
│   └── offer_calculator_test.rb     # Offer calculator tests
├── main.rb                          # Example usage and test cases
└── README.md                        # This file
```

## Design Decisions

1. **Factory Pattern**: `BasketFactory` provides a convenient way to create a basket with default configuration.

2. **Strategy Pattern**: Both delivery calculation and offer calculation use the strategy pattern for flexibility.

3. **Value Objects**: Products are implemented as value objects with proper equality methods.

4. **Defensive Programming**: The basket validates product codes and returns copies of collections to prevent external modification.

5. **Test-Driven Design**: Comprehensive unit tests ensure the system works correctly and can be safely refactored. 