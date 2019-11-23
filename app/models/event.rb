class Event < ApplicationRecord
  has_many :user_events
  include PgSearch::Model
  pg_search_scope :search_by_desc_title_url,
    against: {
      title: 'A',
      description: 'B',
      photo_url: 'C',
      link_url: 'D'
    },
    using: {
      tsearch: { prefix: true } # <-- for partial word search
    }
end
