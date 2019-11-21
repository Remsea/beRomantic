class UserEventsController < ApplicationController
  def index
    if params[:category].present?
      # @userevents = current_user.events.where(category: params[:category])
      query = "events.category = \'#{params[:category]}\'"
      puts "--------------"
      puts "--------------"
    else
      @interests = current_user.interests.map { |interest| interest.title.downcase }
      query = ""
      i = 1
      @interests.each do |interest|
        if i != @interests.size
          query += "events.category = \'#{interest.to_s}\' OR "
        else
          query += "events.category = \'#{interest.to_s}\'"
        end
      i += 1
      end
    end
    @results = Event.where(query.to_s)
  end

  def create
  end

  def destroy
  end
end
