class Partenaire < ApplicationRecord
  belongs_to :user

  validates :firstname, presence: true
end
