class AddUserToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :user, index: true
  end
end
