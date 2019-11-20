class KeyDatesController < ApplicationController
  def create
    @newdate = KeyDate.new(param_data)
    @newdate.user = current_user
    if @newdate.save
      respond_to do |format|
        format.html { redirect_to partenaires_path }
        format.js # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { redirect_to partenaires_path }
        format.js # <-- idem
      end
    end
  end

  def udpate
  end

  def destroy
  end

  private
  def param_data
    params.permit(:date, :description)
  end
end
