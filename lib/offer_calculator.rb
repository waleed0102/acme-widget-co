class OfferCalculator
  def initialize(offers = [])
    @offers = offers
  end

  def add_offer(offer)
    @offers << offer
  end

  def calculate_discount(items)
    @offers.sum { |offer| offer.calculate_discount(items) }
  end
end
