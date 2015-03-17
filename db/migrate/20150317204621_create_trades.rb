class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.decimal :price
      t.decimal :size
    end
  end
end
