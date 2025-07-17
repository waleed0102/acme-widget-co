class BaseOffer
  def calculate_discount(items)
    raise NotImplementedError, "#{self.class} must implement calculate_discount"
  end
end 