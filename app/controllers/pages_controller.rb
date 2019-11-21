class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def index
    # @valeur = current_user.interests.where(genre: "Activité").first.title
    # @list = Event.where(category: "concert")
    # puts @list.first
    # preparer les données pour le calendrier
    # il faudra taper dans les events users + key_date + memo avec calendardate renseignée
    @interests = current_user.interests.map { |interest| interest.title.downcase }
  end
end
