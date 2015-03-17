class Trade < ActiveRecord::Base
	has_and_belongs_to_many :orders, 	join_table: 'orders_trades'
	has_and_belongs_to_many :users,		join_table: 'users_trades'

end