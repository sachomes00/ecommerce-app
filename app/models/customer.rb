class Customer < ApplicationRecord

  def stripe_id
    customer_id
  end
end
