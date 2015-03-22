class AddSideToTrades < ActiveRecord::Migration
  def change
  	add_column :trades, :side, :string
  end
end
