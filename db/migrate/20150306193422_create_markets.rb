class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string        :name
      t.datetime      :start_time
      t.datetime      :end_time
      t.decimal       :min_price
      t.decimal       :max_price
      t.decimal       :first_bid
      t.decimal       :first_bid_size
      t.decimal       :first_offer
      t.decimal       :first_offer_size
      t.integer       :state
    end
  end
end
