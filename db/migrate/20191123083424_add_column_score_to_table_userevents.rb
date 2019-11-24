class AddColumnScoreToTableUserevents < ActiveRecord::Migration[5.2]
  def change
    add_column :user_events, :score, :integer
  end
end
