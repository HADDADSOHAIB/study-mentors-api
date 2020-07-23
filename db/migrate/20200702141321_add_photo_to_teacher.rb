class AddPhotoToTeacher < ActiveRecord::Migration[6.0]
  def change
    add_column :teachers, :photo, :text
  end
end
