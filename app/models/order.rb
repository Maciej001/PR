class Order < ActiveRecord::Base
	belongs_to :user

	enum side: 	[:bid, :offer]
	enum state: [:active, :cancelled, :executed]

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