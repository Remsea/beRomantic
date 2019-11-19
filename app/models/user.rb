class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :partenaires
  has_many :partenaire_interests
  has_many :key_dates
  has_many :user_events
  has_many :memos
end
