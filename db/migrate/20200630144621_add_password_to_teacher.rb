class AddPasswordToTeacher < ActiveRecord::Migration[6.0]
  def change
    add_column :teachers, :password_digest, :string
    add_index :teachers, :email, unique: true
  end
end
