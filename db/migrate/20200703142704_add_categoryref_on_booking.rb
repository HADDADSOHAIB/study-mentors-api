class AddCategoryrefOnBooking < ActiveRecord::Migration[6.0]
  def change
    add_reference(:bookings, :category)
  end
end
