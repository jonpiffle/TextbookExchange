class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :dept
      t.string :course_num
      t.string :amazon_url
      t.string :isbn_10
      t.string :isbn_13
      t.string :author
      t.string :publisher
      t.string :edition
      t.integer :user_id
      t.text :notes
      t.string :condition

      t.timestamps
    end
  end
end
