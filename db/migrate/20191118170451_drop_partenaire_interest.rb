class DropPartenaireInterest < ActiveRecord::Migration[5.2]
  def change
    drop_table :partenaire_interests
  end
end
