class AddStartDateEndDatePhotoUrlLinkUrlToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :start_date, :date
    add_column :events, :end_date, :date
    add_column :events, :photo_url, :string
    add_column :events, :link_url, :string
  end
end
