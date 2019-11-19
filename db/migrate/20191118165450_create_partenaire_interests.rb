class CreatePartenaireInterests < ActiveRecord::Migration[5.2]
  def change
    create_table :partenaire_interests do |t|
      t.references :user
      t.references :interest

      t.timestamps
    end
  end
end
