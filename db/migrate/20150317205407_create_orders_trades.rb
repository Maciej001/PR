class CreateOrdersTrades < ActiveRecord::Migration
  def change
    create_table :orders_trades, id: false do |t|
    	t.integer	:order_id
    	t.integer	:trade_id
    end

    add_index :orders_trades, :order_id
    add_index :orders_trades, :trade_id
  end
end
