class UserEventsController < ApplicationController
  def index
    @events = current_user.user_events
  end

  def create
  end

  def destroy
  end

end
