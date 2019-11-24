class ChangeColumnDefaultCalendarUserEvent < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:user_events, :calendar, false)
  end
end
