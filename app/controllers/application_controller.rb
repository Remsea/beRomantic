class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  def default_url_options
  { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  def after_sign_in_path_for(resource)
    pages_path
  end

  private

  def caleventnumber
    id = current_user.id
    sql = "with table_cal as
    ((select id, current_date as date, 4 as score from key_dates where user_id = #{id})
    union
    (select id, calendardate as date, 2 as score from memos
    where user_id = #{id} and calendardate is not null)
    union
    (select e.id, e.start_date as date, 11 as score
    from user_events u
    inner join events e on e.id = u.event_id
    where u.user_id = #{id}  and u.calendar = true and e.start_date is not null))
    select count(id), sum(score) from table_cal
    where date >= current_date and date >= current_date - 60;"
    @caleventnum ||= ActiveRecord::Base.connection.execute(sql).values
  end
end
