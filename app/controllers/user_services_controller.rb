class UserServicesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update_user_ajax
    user = current_user
    user.update(subscription: JSON.parse(params["subscription"]))
  end
end
