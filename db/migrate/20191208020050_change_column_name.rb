class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :charge_id, :payment_intent_id
  end
end
