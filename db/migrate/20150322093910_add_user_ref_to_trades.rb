class AddUserRefToTrades < ActiveRecord::Migration
  def change
    add_reference :trades, :user, index: true
    add_foreign_key :trades, :users
    add_column :trades, :created_at, :datetime 
    add_column :trades, :updated_at, :datetime 
  end
end
