class AddStripePlanToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :stripe_plan, :string
  end
end
