class AddCalendarToEventUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :user_events, :calendar, :boolean
  end
end
