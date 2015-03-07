class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.integer	:side		# enum value [:bid, :offer]
    	t.integer :state	# enum value [:active, :cancelled, :executed]
    	t.decimal	:price
    	t.decimal :size
    end
  end
end
