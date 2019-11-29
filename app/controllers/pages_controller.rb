class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  MONTH = %w[Janvier Février Mars Avril Mai Juin Juillet Août Septembre Octobre Novembre Décembre]
  def home
    set_insta
  end

  def index
    # no more useful as the input form has disapeared
    if params[:nb].present?
      @results_sql = calquery(current_user.id, 360, params[:nb])
      render partial: 'calendarseule', locals: { results_sql: @results_sql }

    else
      @results_sql = calquery(current_user.id, 360, 5)
      caleventnumber
      @nbvisu = 5
      selectquatre
      # if current_user.dateinsta != Date.today
      set_insta
      current_user.update(dateinsta: Date.today)
      # end
      if !flash['nocalcul']
        if current_user.datescrap != Date.today
          usereventbuilder
          current_user.update(datescrap: Date.today)

        end
      end
    end
  end

  private

  def calquery(id, jour, nb_element)
    sql = "with anni as
(select 'keydate' as categorie, k.id, (extract(year from current_date) - extract(year from k.date)) as diff, k.date + (extract(year from current_date) - EXTRACT(YEAR FROM k.date) || ' years')::interval as date, extract(year from current_date) as year, extract(month from k.date) as month,extract(day from k.date) as day, k.description as description from key_dates k
where k.user_id = #{id}), alldate as
((select 'memo' as categorie, m.id, 0 as diff, m.calendardate as date, extract(year from m.calendardate) as year,extract(month from m.calendardate) as month,extract(day from m.calendardate) as day, m.content as description from memos m
where m.user_id = #{id} and calendardate is not null)
union
(select * from anni)
union
(select categorie, id, diff + 1, date + (extract(year from current_date) - EXTRACT(YEAR FROM date) + 1 || ' years')::interval as date, year + 1, month, day, description from anni)
union
(select 'event' as categorie, e.id, 0 as diff, e.start_date as date, extract(year from e.start_date) as year, extract(month from e.start_date) as month , extract(day from e.start_date) as day ,  case when ((e.title=' ') or (e.title is null)) then LEFT(e.description, 30)
else REGEXP_REPLACE(e.title,'[\n\r]+','')
end description
from user_events u
inner join events e on e.id = u.event_id
where u.user_id = #{id} and u.calendar = true ))
select * from alldate
where date > current_date - 5 and date < current_date + #{jour.to_i}
order by date asc
limit #{nb_element.to_i};"

  ActiveRecord::Base.connection.execute(sql)
  end

  def usereventbuilder
    # Construire la table user_event avec la sélection des events en fct des activites (score = 1)
    current_user.user_events.where('calendar IS NULL OR calendar = ?', [false]).destroy_all

    activites = current_user.interests.map { |interest|  interest.title.downcase if interest.genre = 'Activité' }
      query = ""
      i = 1
      activites.each do |activite|
        if i != activites.size
          query += "events.category = \'#{activite.to_s}\' OR "
        else
          query += "events.category = \'#{activite.to_s}\'"
        end
        i += 1
      end

    event_id_matching_activite = Event.where(query.to_s).select("id")
    # byebug
    # on cree les evenements dans la table user_event qui matche les activites (concert, theatre...)
    event_id_matching_activite.each do |event|
      if UserEvent.find_by(event_id: event.id, user_id: current_user.id).nil?
        newevent = UserEvent.new(event_id: event.id, score: 1)
        newevent.user = current_user
        newevent.save!
      end
    end

    # augmentation du score en fct des interets presents dans la description ou le titre
    centre_interet = current_user.interests.map { |interest|  interest.title.downcase if interest.genre = "Centre d'intérêt" }
    centre_interet.each do |interet|
      @pgsearch = Event.search_by_desc_title_url(interet).with_pg_search_rank
          @pgsearch.each do |r|
            event = UserEvent.find_by(event_id: r.id, user_id: current_user.id)
            unless event.nil?
             event.score += ((r.pg_search_rank * 10).to_f).round
              event.save!
            end
          end
    end
    # @userevents = current_user.user_events.order(:score).reverse_order.first(4)
    selectquatre
  end

  def selectquatre
    @userevents = Event.joins(:user_events).where("user_events.user_id = ?",[current_user.id])
    .order(score: :desc).limit(4)
  end

  def set_insta
    url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=25064177769.1677ed0.8bf171bb5f7a4fcc8995d4172178df73"
    user_serialized = RestClient.get(url).body
    user = JSON.parse(user_serialized)
    # @full_name = user['data'].first['user']['full_name']
    # @profile_picture = user['data'].first['user']['profile_picture']
    data = user['data']
    @images = []
    data.each do |hash|
      hash_image = {
        url: hash['images']['low_resolution']['url'],
        created_time: hash['created_time']
      }
      @images << hash_image
    end

    @dates = []
    data.each do |times|
      @dates << times['created_time']
    end
  rescue OpenURI::HTTPError
    @dates = []
    @images =[]
  end
end
