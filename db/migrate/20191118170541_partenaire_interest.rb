class PartenaireInterest < ActiveRecord::Migration[5.2]
  def change
    create_table :partenaire_interests do |t|
      t.references :user, foreign_key: true
      t.references :interest, foreign_key: true

      t.timestamps
    end
  end
end
