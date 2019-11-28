class AddColumnDatescrapToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :datescrap, :date
    add_column :users, :dateinsta, :date
  end
end
