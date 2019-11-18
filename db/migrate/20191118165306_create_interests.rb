class CreateInterests < ActiveRecord::Migration[5.2]
  def change
    create_table :interests do |t|
      t.string :title
      t.string :category
      t.string :genre

      t.timestamps
    end
  end
end
