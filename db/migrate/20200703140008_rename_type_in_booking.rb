class RenameTypeInBooking < ActiveRecord::Migration[6.0]
  def change
    rename_column :bookings, :type, :session_type
  end
end
