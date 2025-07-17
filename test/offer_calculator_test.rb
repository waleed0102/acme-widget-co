require 'minitest/autorun'
require_relative '../lib/offer_calculator'
require_relative '../lib/offers/buy_one_get_one_half_price'
require_relative '../lib/product'

class OfferCalculatorTest < Minitest::Test
  def setup
    @calculator = OfferCalculator.new
    @red_widget = Product.new('R01', 'Red Widget', 32.95)
    @green_widget = Product.new('G01', 'Green Widget', 24.95)
  end

  def test_no_offers_no_discount
    items = [@red_widget, @green_widget]
    assert_equal 0, @calculator.calculate_discount(items)
  end

  def test_single_red_widget_no_discount
    @calculator.add_offer(BuyOneGetOneHalfPrice.new('R01'))
    items = [@red_widget]
    assert_equal 0, @calculator.calculate_discount(items)
  end

  def test_two_red_widgets_half_price_second
    @calculator.add_offer(BuyOneGetOneHalfPrice.new('R01'))
    items = [@red_widget, @red_widget]
    expected_discount = 32.95 * 0.5
    assert_in_delta expected_discount, @calculator.calculate_discount(items), 0.01
  end

  def test_three_red_widgets_half_price_second
    @calculator.add_offer(BuyOneGetOneHalfPrice.new('R01'))
    items = [@red_widget, @red_widget, @red_widget]
    expected_discount = 32.95 * 0.5  # Only second one gets discount
    assert_in_delta expected_discount, @calculator.calculate_discount(items), 0.01
  end

  def test_four_red_widgets_half_price_second_and_fourth
    @calculator.add_offer(BuyOneGetOneHalfPrice.new('R01'))
    items = [@red_widget, @red_widget, @red_widget, @red_widget]
    expected_discount = 32.95 * 0.5 * 2  # Second and fourth get discount
    assert_in_delta expected_discount, @calculator.calculate_discount(items), 0.01
  end

  def test_multiple_offers
    @calculator.add_offer(BuyOneGetOneHalfPrice.new('R01'))
    @calculator.add_offer(BuyOneGetOneHalfPrice.new('G01'))

    items = [@red_widget, @red_widget, @green_widget, @green_widget]
    expected_discount = (32.95 * 0.5) + (24.95 * 0.5)
    assert_in_delta expected_discount, @calculator.calculate_discount(items), 0.01
  end
end

class BuyOneGetOneHalfPriceTest < Minitest::Test
  def setup
    @offer = BuyOneGetOneHalfPrice.new('R01')
    @red_widget = Product.new('R01', 'Red Widget', 32.95)
    @green_widget = Product.new('G01', 'Green Widget', 24.95)
  end

  def test_no_matching_products
    items = [@green_widget, @green_widget]
    assert_equal 0, @offer.calculate_discount(items)
  end

  def test_single_matching_product
    items = [@red_widget]
    assert_equal 0, @offer.calculate_discount(items)
  end

  def test_two_matching_products
    items = [@red_widget, @red_widget]
    expected_discount = 32.95 * 0.5
    assert_in_delta expected_discount, @offer.calculate_discount(items), 0.01
  end

  def test_three_matching_products
    items = [@red_widget, @red_widget, @red_widget]
    expected_discount = 32.95 * 0.5  # Only second one gets discount
    assert_in_delta expected_discount, @offer.calculate_discount(items), 0.01
  end
end
