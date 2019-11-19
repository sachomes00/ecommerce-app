class ShoppingCart < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items

  def subtotal
    sum = 0
    self.line_items.each do |line_item|
      sum+= line_item.total_price
    end
    sum
  end

  def subtotal_cents
    (subtotal * 100).to_i
  end
end
