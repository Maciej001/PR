class CreateUsersTrades < ActiveRecord::Migration
  def change
    create_table :users_trades, id: false do |t|
    	t.integer :trade_id
    	t.integer :user_id
    end

    add_index :users_trades, :trade_id
    add_index :users_trades, :user_id
  end
end
