class User < ActiveRecord::Base
	has_many :orders
	has_and_belongs_to_many :trades, join_table: 'users_trades'

	# using enum
	# rails generates helper methods user.user? and user.admin?
	# 
	# user.user! and user.admin!
	enum role: [:user, :admin]
	after_initialize :set_default_role, if: :new_record?

	def set_default_role
		self.role ||= :user
	end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
