require_relative 'product'

class ProductCatalogue
  def initialize(products = [])
    @products = products
  end

  def add_product(product)
    @products << product
  end

  def find(code)
    @products.find { |product| product.code == code }
  end

  def all
    @products.dup
  end
end
