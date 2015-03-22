class Order < ActiveRecord::Base
	belongs_to :user

	# There is a problem in 4.1 Rails
	# Active record throws an Argument Error in RailsAdmin::MainController#new 
	# '1' is not a valid state
	# it has been solved by gist from https://github.com/sferik/rails_admin/issues/1993
	# added in config/initializers/rails_enum.rb
	enum side: 	[:bid, :offer]
	enum state: [:active, :executed]

	validates :price, presence: true, numericality: { greater_than: 0 }
	validates :size, 	presence: true, numericality: { greater_than: 0 }
	validates	:side, 	presence: true
	validates :state,	presence: true

	after_initialize :set_default_state, if: :new_record?

	def set_default_state
		# initializes new order as active
		self.state ||= :active
	end
end