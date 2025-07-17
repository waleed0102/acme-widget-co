require_relative 'base_offer'

class BuyOneGetOneHalfPrice < BaseOffer
  def initialize(product_code)
    @product_code = product_code
  end

  def calculate_discount(items)
    matching_items = items.select { |item| item.code == @product_code }
    return 0 if matching_items.length < 2

    # Calculate how many pairs we have
    pairs = matching_items.length / 2
    # Each pair gets 50% off the second item
    discount_per_pair = matching_items.first.price * 0.5

    pairs * discount_per_pair
  end
end
