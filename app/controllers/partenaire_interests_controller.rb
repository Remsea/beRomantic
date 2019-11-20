class PartenaireInterestsController < ApplicationController
  def create
    @part_interest = PartenaireInterest.new(get_param)
    @part_interest.user = current_user

    if @part_interest.save
      respond_to do |format|
        format.html { redirect_to partenaires_path }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { redirect_to partenaires_path }
        format.js  # <-- idem
      end
    end
  end

  def destroy
  end

  private

  def get_param
    params.permit(:interest_id)
  end
end
