class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    set_insta
  end

  def index
    # preparer les données pour le calendrier
    # il faudra taper dans les events users + key_date + memo avec calendardate renseignée
  end

  private

  def set_insta
    url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=25064177769.1677ed0.8bf171bb5f7a4fcc8995d4172178df73"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    @full_name = user['data'].first['user']['full_name']
    @profile_picture = user['data'].first['user']['profile_picture']
    @image = user['data'].first['images']['low_resolution']['url']
  end
end
