class Market < ActiveRecord::Base
	enum state: [:open, :closed]
	after_initialize :set_default_state, if: :new_record?

	def set_default_state
		self.state ||= :closed
	end

end