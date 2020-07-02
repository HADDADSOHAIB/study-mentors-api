class CreateJoinCategoryTeachers < ActiveRecord::Migration[6.0]
  def change
    create_table :join_category_teachers do |t|
      t.references :teacher, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
