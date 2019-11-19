class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def index

    # preparer les données pour le calendrier
    # il faudra taper dans les events users + key_date + memo avec calendardate renseignée
  end
end
