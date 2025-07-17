require_relative 'basket'
require_relative 'product_catalogue'
require_relative 'product'
require_relative 'delivery_calculator'
require_relative 'offer_calculator'
require_relative 'offers/buy_one_get_one_half_price'

class BasketFactory
  def self.create_default_basket
    # Create product catalogue with Acme Widget Co products
    catalogue = ProductCatalogue.new
    catalogue.add_product(Product.new('R01', 'Red Widget', 32.95))
    catalogue.add_product(Product.new('G01', 'Green Widget', 24.95))
    catalogue.add_product(Product.new('B01', 'Blue Widget', 7.95))

    # Create delivery calculator with Acme Widget Co rules
    delivery_calculator = DeliveryCalculator.new

    # Create offer calculator with the red widget offer
    offer_calculator = OfferCalculator.new
    offer_calculator.add_offer(BuyOneGetOneHalfPrice.new('R01'))

    # Create and return the basket
    Basket.new(catalogue, delivery_calculator, offer_calculator)
  end
end
