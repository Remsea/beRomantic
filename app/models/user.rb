class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
  has_many :partenaires
  has_many :partenaire_interests
  has_many :interests, through: :partenaire_interests
  has_many :key_dates
  has_many :user_events
  has_many :memos

  after_create :create_partner

  def self.find_for_facebook_oauth(auth)
    user_params = auth.slice("provider", "uid")
    user_params.merge! auth.info.slice("email", "first_name", "last_name")
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]
      user.save
    end
    return user
  end

  def send_notif
    Webpush.payload_send(
      message: "Coucou",
      endpoint: subscription['endpoint'],
      p256dh: subscription['keys']['p256dh'],
      auth: subscription['keys']['auth'],
      vapid: {
        subject: "mailto:sender@example.com",
        public_key: ENV['PUBLIC_KEY'],
        private_key: ENV['PRIVATE_KEY']
      },
      ssl_timeout: 5, # value for Net::HTTP#ssl_timeout=, optional
      open_timeout: 5, # value for Net::HTTP#open_timeout=, optional
      read_timeout: 5 # value for Net::HTTP#read_timeout=, optional
    )
  end

  def create_partner
    Partenaire.create(user: self)
  end
end
