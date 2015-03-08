class AddDefaultValueToOrderSide < ActiveRecord::Migration
  def change
  	change_column :orders, :side, :integer, :default => 0
  end
end
