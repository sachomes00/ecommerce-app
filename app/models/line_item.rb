class LineItem < ApplicationRecord
  belongs_to :shopping_cart, optional: true
  belongs_to :product
  belongs_to :order, optional: true

  def total_price
    self.quantity * self.product.price
  end

  def total_cents
    total_price * 100
  end
end
