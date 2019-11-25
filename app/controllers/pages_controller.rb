class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  MONTH = %w[Janvier Février Mars Avril Mai Juin Juillet Août Septembre Octobre Novembre Décembre]
  def home
    set_insta
  end

  def index
    # preparer les données pour le calendrier
    @calendar = calendar_update
    if params[:nb_jour_pre].present? && params[:nb_jour_post].present?
      @shortcalendar = shortcalendar(@calendar, params[:nb_jour_pre].to_i, params[:nb_jour_post].to_i)
    else
      @shortcalendar = shortcalendar(@calendar)
    end
    usereventbuilder
    set_insta
  end

  private

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
            event = UserEvent.find_by(event_id: r.id)
            unless event.nil?
             event.score += ((r.pg_search_rank * 10).to_f).round
              event.save!
            end
          end
    end
    # @userevents = current_user.user_events.order(:score).reverse_order.first(4)
    @userevents = Event.joins(:user_events).where("user_events.user_id = ?",[current_user.id])
    .order(:score).reverse_order.first(4)
  end

  def set_insta
    url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=25064177769.1677ed0.8bf171bb5f7a4fcc8995d4172178df73"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    @full_name = user['data'].first['user']['full_name']
    @profile_picture = user['data'].first['user']['profile_picture']
    data = user['data']
    @images = []
    data.each do |hash|
      @images << hash['images']['low_resolution']['url']
    end
  end

  # apercu calendrier en fct du jour J et d'une periode avant et après
  def shortcalendar(calendar, nb_jours_pre = 5, nb_jours_post = 5)
    current_year = Date.today.year
    current_month = Date.today.month
    prev_month = current_month - 1
    next_month = current_month + 1
    current_day = Date.today.day
    jour_fin_mois = Date.today.end_of_month.day
    intervalle_fin_mois = jour_fin_mois - Date.today.day

    if (nb_jours_pre > current_day) && (nb_jours_post > intervalle_fin_mois)
      @partialcalendar = calendar[current_year][current_month].select { |k, v| true}
      @partialcalendar2 = calendar[current_year][current_month - 1].select { |k, v| (k >= (Date.today.prev_month.end_of_month.day - nb_jours_pre + current_day)) }
      @partialcalendar3 = calendar[current_year][next_month].select { |k, v| (k <= (nb_jours_post - (jour_fin_mois - current_day))) }
      @partialcalendar =
      {
        prev_month => @partialcalendar2,
        current_month => @partialcalendar,
        next_month => @partialcalendar3
      }
    elsif nb_jours_pre > current_day
      @partialcalendar = calendar[current_year][current_month].select { |k, v| (k < (current_day + nb_jours_post)) }
      @partialcalendar2 = calendar[current_year][current_month - 1].select { |k, v| (k >= (Date.today.prev_month.end_of_month.day - nb_jours_pre + current_day)) }
      @partialcalendar =
      {
        prev_month => @partialcalendar2,
        current_month => @partialcalendar
      }
    elsif nb_jours_post > intervalle_fin_mois
      @partialcalendar = calendar[current_year][current_month].select { |k, v| (k >= current_day) }
      @partialcalendar2 = calendar[current_year][next_month].select { |k, v| (k <= (nb_jours_post - (jour_fin_mois - current_day))) }
      @partialcalendar =
      {
        current_month => @partialcalendar,
        next_month => @partialcalendar2
      }

    else

      @partialcalendar = calendar[current_year][current_month].select { |k, v| (k <= (current_day + nb_jours_post)) && (k >= (current_day - nb_jours_post)) }
      @partialcalendar =
      {
      current_month => @partialcalendar
      }
    end
    return @partialcalendar
  end
  # construction d'un hash contenant 3 années mois et jours nestés
  def calendar_builder
    calendar = {}
    yearmonth = {}
    monthday = {}
    current_year = Date.today.year
    scope_year = [current_year.to_i - 1, current_year.to_i, current_year.to_i + 1]
    months = Date::MONTHNAMES

    scope_year.each do |year|
      i = 1;
      12.times do
        day = 1
        (Time.days_in_month(i, year) + 1).times do |day|
          monthday.store(day, {})
        end
        yearmonth[i] = monthday
        i += 1
        monthday = {}
      end
     calendar[year] = yearmonth
     yearmonth ={}
    end
    return calendar
  end

  # mise à jour du hash calendrier avec les memos id et les keydate ids a la bonne date
  def calendar_update
    @calendarbis = calendar_builder
    current_year = Date.today.year

    current_user.key_dates.each do |keydate_param|
      myhash = {Keydate: [keydate_param.id]}
      @calendarbis[current_year][keydate_param.date.month][keydate_param.date.day].merge!(myhash) {|key, oldval, newval| oldval.class == Array ? oldval | newval : [newval, oldval]}
    end

    current_user.memos.each do |memo|
      unless memo.calendardate.nil?
        myhash = {Memo: [memo.id]}
        @calendarbis[memo.calendardate.year][memo.calendardate.month][memo.calendardate.day].merge!(myhash) {|key, oldval, newval| oldval.class == Array ? oldval | newval : [newval, oldval]}
      end
    end
    current_user.events.each do |event|
      if current_user.user_events.find_by(event_id: event.id).calendar == true
        myhash = {Event: [event.id]}
        @calendarbis[event.start_date.year][event.start_date.month][event.start_date.day].merge!(myhash) {|key, oldval, newval| oldval.class == Array ? oldval | newval : [newval, oldval]}
      end
    end

    return @calendarbis
  end

  # def calendar_old
  #   # stocker date, model, id
  #   @calendarbis = calendar_builder
  #   @calendar = {}
  #   current_year = Date.today.year
  #   current_user.key_dates.each do |keydate_param|
  #     if @calendar[current_year].nil?
  #       @calendar[current_year] = {keydate_param.date.month => {keydate_param.date.day => {:Keydate => [keydate_param.id] }}}
  #     elsif @calendar[current_year][keydate_param.date.month].nil?
  #       @calendar[current_year][keydate_param.date.month] = {keydate_param.date.day => {:Keydate => [keydate_param.id] }}
  #     elsif @calendar[current_year][keydate_param.date.month][keydate_param.date.day].nil?
  #       @calendar[current_year][keydate_param.date.month][keydate_param.date.day] = {:Keydate => [keydate_param.id]}
  #     elsif @calendar[current_year][keydate_param.date.month][keydate_param.date.day][:keydate].nil?
  #         @calendar[current_year][keydate_param.date.month][keydate_param.date.day][:keydate] = [keydate_param.id]
  #         # @calendar[current_year.to_s.to_sym][keydate_param.date.month.to_s.to_sym][keydate_param.date.day.to_s.to_sym][keydate_param.id.to_s.to_sym] = 'Keydate'
  #     else
  #         @calendar[current_year][keydate_param.date.month][keydate_param.date.day][:keydate] << keydate_param.id
  #     end
  #   end

  #   current_user.memos.each do |memo|
  #     unless (memo.calendardate == '' || memo.calendardate.year < current_year)
  #       if @calendar[current_year].nil?
  #         @calendar[current_year] = {memo.calendardate.month => {memo.calendardate.day => {:Memo => [memo.id] }}}
  #       elsif @calendar[current_year][memo.calendardate.month].nil?
  #         @calendar[current_year][memo.calendardate.month] = {memo.calendardate.day => {:Memo => [memo.id] }}
  #       elsif @calendar[current_year][memo.calendardate.month][memo.calendardate.day].nil?
  #         @calendar[current_year][memo.calendardate.month][memo.calendardate.day] = {:Memo => [memo.id]}
  #       elsif @calendar[current_year][memo.calendardate.month][memo.calendardate.day][:Memo].nil?
  #           @calendar[current_year][memo.calendardate.month][memo.calendardate.day][:Memo] = [memo.id]
  #       else
  #           @calendar[current_year][memo.calendardate.month][memo.calendardate.day][:Memo] << memo.id
  #       end
  #     end
  #   end
  # end
end
