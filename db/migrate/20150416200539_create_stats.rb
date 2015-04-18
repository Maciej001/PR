class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
    	t.decimal :total_contracts_traded, 	default: 0
    	t.decimal :number_of_trades, 				default: 0
    	t.decimal :open,										default: 0
    	t.decimal :high,										default: 0
    	t.decimal :low,											default: 0
    	t.decimal :last,										default: 0

      t.timestamps null: false
    end
  end
end
