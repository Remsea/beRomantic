class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  MONTH = %w[Janvier Février Mars Avril Mai Juin Juillet Août Septembre Octobre Novembre Décembre]
  def home
    set_insta
  end

  def index

    @calendar = calendar
    if params[:nb_jour_pre].present? && params[:nb_jour_post].present?
    @shortcalendar = shortcalendar(@calendar, params[:nb_jour_pre].to_i, params[:nb_jour_post].to_i)
    else
    @shortcalendar = shortcalendar(@calendar)
    end
    # preparer les données pour le calendrier
    # il faudra taper dans les events users + key_date + memo avec calendardate renseignée
    @interests = current_user.interests.map { |interest| interest.title.downcase }
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

  def calendar
    @calendarbis = calendar_builder
    current_year = Date.today.year

    current_user.key_dates.each do |keydate_param|
      myhash = {Keydate: [keydate_param.id]}
      @calendarbis[current_year][keydate_param.date.month][keydate_param.date.day].merge!(myhash) {|key, oldval, newval| oldval.class == Array ? oldval | newval : [newval, oldval]}
    end

    current_user.memos.each do |memo|
      myhash = {Memo: [memo.id]}
      @calendarbis[memo.calendardate.year][memo.calendardate.month][memo.calendardate.day].merge!(myhash) {|key, oldval, newval| oldval.class == Array ? oldval | newval : [newval, oldval]}
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
