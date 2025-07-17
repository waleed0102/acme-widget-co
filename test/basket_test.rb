require 'minitest/autorun'
require_relative '../lib/basket'
require_relative '../lib/product_catalogue'
require_relative '../lib/product'
require_relative '../lib/delivery_calculator'
require_relative '../lib/offer_calculator'
require_relative '../lib/offers/buy_one_get_one_half_price'

class BasketTest < Minitest::Test
  def setup
    @catalogue = ProductCatalogue.new
    @catalogue.add_product(Product.new('R01', 'Red Widget', 32.95))
    @catalogue.add_product(Product.new('G01', 'Green Widget', 24.95))
    @catalogue.add_product(Product.new('B01', 'Blue Widget', 7.95))
    
    @delivery_calculator = DeliveryCalculator.new
    @offer_calculator = OfferCalculator.new
    @offer_calculator.add_offer(BuyOneGetOneHalfPrice.new('R01'))
    
    @basket = Basket.new(@catalogue, @delivery_calculator, @offer_calculator)
  end

  def test_add_product
    @basket.add('R01')
    assert_equal 1, @basket.items.length
    assert_equal 'R01', @basket.items.first.code
  end

  def test_add_invalid_product_raises_error
    assert_raises(ArgumentError) do
      @basket.add('INVALID')
    end
  end

  def test_basket_b01_g01_total
    @basket.add('B01')
    @basket.add('G01')
    # Subtotal: 7.95 + 24.95 = 32.90
    # Delivery: 4.95 (under $50)
    # Total: 32.90 + 4.95 = 37.85
    assert_in_delta 37.85, @basket.total, 0.01
  end

  def test_basket_r01_r01_total
    @basket.add('R01')
    @basket.add('R01')
    # Subtotal: 32.95 + 32.95 = 65.90
    # Discount: 16.475 (50% off second R01)
    # After discount: 65.90 - 16.475 = 49.425
    # Delivery: 4.95 (under $50)
    # Total: 49.425 + 4.95 = 54.375 ≈ 54.37
    assert_in_delta 54.37, @basket.total, 0.01
  end

  def test_basket_r01_g01_total
    @basket.add('R01')
    @basket.add('G01')
    # Subtotal: 32.95 + 24.95 = 57.90
    # No discount (only one R01)
    # Delivery: 2.95 (under $90)
    # Total: 57.90 + 2.95 = 60.85
    assert_in_delta 60.85, @basket.total, 0.01
  end

  def test_basket_b01_b01_r01_r01_r01_total
    @basket.add('B01')
    @basket.add('B01')
    @basket.add('R01')
    @basket.add('R01')
    @basket.add('R01')
    # Subtotal: 7.95 + 7.95 + 32.95 + 32.95 + 32.95 = 114.75
    # Discount: 16.475 (50% off second R01, third R01 full price)
    # After discount: 114.75 - 16.475 = 98.275
    # Delivery: 0 (over $90)
    # Total: 98.275 ≈ 98.27
    assert_in_delta 98.27, @basket.total, 0.01
  end

  def test_items_returns_copy
    @basket.add('R01')
    items = @basket.items
    items << Product.new('G01', 'Green Widget', 24.95)
    
    assert_equal 1, @basket.items.length
    assert_equal 2, items.length
  end
end 