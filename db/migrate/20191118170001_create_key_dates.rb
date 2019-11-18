class CreateKeyDates < ActiveRecord::Migration[5.2]
  def change
    create_table :key_dates do |t|
      t.date :date
      t.string :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
