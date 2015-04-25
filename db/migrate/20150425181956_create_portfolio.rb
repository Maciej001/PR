class CreatePortfolio < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.integer :user_id
      t.decimal :cash
      t.decimal :open_position
    end
  end
end
