class FixCategoryOnBooking < ActiveRecord::Migration[6.0]
  def change
    remove_column :bookings, :category_id
  end
end
