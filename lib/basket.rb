require_relative 'product_catalogue'
require_relative 'delivery_calculator'
require_relative 'offer_calculator'

class Basket
  def initialize(product_catalogue, delivery_calculator, offer_calculator)
    @product_catalogue = product_catalogue
    @delivery_calculator = delivery_calculator
    @offer_calculator = offer_calculator
    @items = []
  end

  def add(product_code)
    product = @product_catalogue.find(product_code)
    raise ArgumentError, "Product with code '#{product_code}' not found" unless product

    @items << product
  end

  def total
    subtotal = calculate_subtotal
    discount = @offer_calculator.calculate_discount(@items)
    delivery_cost = @delivery_calculator.calculate_delivery_cost(subtotal - discount)

    subtotal - discount + delivery_cost
  end

  def items
    @items.dup
  end

  private

  def calculate_subtotal
    @items.sum(&:price)
  end
end
