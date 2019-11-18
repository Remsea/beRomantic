class CreatePartenaires < ActiveRecord::Migration[5.2]
  def change
    create_table :partenaires do |t|
      t.references :user, foreign_key: true
      t.string :firstname
      t.string :lastname
      t.string :facebook_username
      t.string :instragram_username
      t.string :twitter_username
      t.string :pinterest_username
      t.string :photo
      t.timestamps
    end
  end
end
