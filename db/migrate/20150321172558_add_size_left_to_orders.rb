class AddSizeLeftToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :size_left, :decimal
  end
end
