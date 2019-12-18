class AddIsSubscriptionToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :is_subscription, :boolean
  end
end
