class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.date :date
      t.string :category
      t.string :address
      t.string :latitute
      t.string :longitude

      t.timestamps
    end
  end
end
