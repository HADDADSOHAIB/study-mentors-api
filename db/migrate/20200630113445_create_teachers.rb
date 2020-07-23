class CreateTeachers < ActiveRecord::Migration[6.0]
  def change
    create_table :teachers do |t|
      t.string :fullname
      t.string :email
      t.string :phone
      t.text :bio
      t.text :what_I_can_do
      t.json :schedule
      t.string :session_type

      t.timestamps
    end
  end
end
