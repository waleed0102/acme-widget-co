require 'minitest/autorun'
require_relative '../lib/delivery_calculator'

class DeliveryCalculatorTest < Minitest::Test
  def setup
    @calculator = DeliveryCalculator.new
  end

  def test_delivery_cost_under_50
    assert_equal 4.95, @calculator.calculate_delivery_cost(25.00)
    assert_equal 4.95, @calculator.calculate_delivery_cost(49.99)
  end

  def test_delivery_cost_under_90
    assert_equal 2.95, @calculator.calculate_delivery_cost(50.00)
    assert_equal 2.95, @calculator.calculate_delivery_cost(89.99)
  end

  def test_free_delivery_over_90
    assert_equal 0, @calculator.calculate_delivery_cost(90.00)
    assert_equal 0, @calculator.calculate_delivery_cost(150.00)
  end
end
