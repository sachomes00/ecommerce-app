class AddStripeCustomerIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :strip_customer_id, :string
  end
end
