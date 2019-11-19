class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.float :total
      t.string :charge_id
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
