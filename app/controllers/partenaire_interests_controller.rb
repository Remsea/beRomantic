class PartenaireInterestsController < ApplicationController
  def create
    # controle de l'absence de cet interet chez le partenaire
    if !controle_existence_id(param_data)
      @part_interest = PartenaireInterest.new(param_data)
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
    else
      respond_to do |format|
        format.html do
          flash[:notice] = current_user.interests.find(param_data[:interest_id]).title + ' est déjà présent'
          @partenaires = current_user.partenaires
          render 'partenaires/index'
        end
        format.js do
          flash[:notice] = current_user.interests.find(param_data[:interest_id]).title + ' est déjà présent'
          render :notice_js
        end
      end
    end
  end

  def destroy
  end

  private

  def param_data
    if !params[:interest_id].nil?
      params.permit(:interest_id)
    elsif !params[:activite_id].nil?
      {
        interest_id: params[:activite_id]
      }
    end
  end

  def controle_existence_id(hash)
    current_user.interests.ids.include?(hash[:interest_id].to_i)
  end
end
