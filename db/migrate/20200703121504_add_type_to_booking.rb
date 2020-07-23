class AddTypeToBooking < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :type, :string
  end
end
